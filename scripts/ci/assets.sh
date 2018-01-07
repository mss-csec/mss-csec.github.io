#!/usr/bin/env bash

# Exit if any subcommand fails
set -e

echo "Starting build"
echo

# Delete previous deploy branch, if it exists
# Necessary given caching
if [ `git branch | grep $DEPLOY_BRANCH` ]; then
  git branch -D $DEPLOY_BRANCH
fi

# Create new deploy branch
git checkout --orphan $DEPLOY_BRANCH

# Build assets
chmod +x ./scripts/build.js
if [ "$1" != "production" ]; then
  time ./scripts/build.js
else
  time ./scripts/build.js $1
fi

# Delete files
find . -maxdepth 1 \
    ! -name '.git' ! -name '.gitignore' ! -name 'assets' \
    ! -name 'scripts' ! -name '.circleci' ! -name '.vagrant' \
    ! -name '.' \
    -exec rm -rf {} \;
find assets/ -type f ! -name '*.css' ! -name '*.js' -exec rm -f {} \;

# Add assets
git add -A .
git add -f assets/
git commit -m "assets $CIRCLE_SHA1"

# Push baby push
if [ "${CIRCLE_BRANCH}" == "staging" ]; then
  git push -f origin $DEPLOY_BRANCH
fi

# Cleanup
echo "Cleaning up..."
git checkout $SOURCE_BRANCH
git checkout -- ./scripts/ci/assets.sh # This script tends to get deleted
git branch -D $DEPLOY_BRANCH

echo "Build successful"

exit 0
