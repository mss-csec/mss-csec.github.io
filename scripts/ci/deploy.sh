#!/usr/bin/env sh

# Exit if any subcommand fails
set -e

echo "Starting deploy"

# Save the previous commit hash for future reference
commit="$(git log -1 --pretty=%h)"

# Delete previous build branch, if it exists
# Necessary given caching
if [ `git branch | grep $DEPLOY_BRANCH` ]; then
  git branch -D $DEPLOY_BRANCH
fi

# Create the deploy branch as an orphan
git checkout --orphan $DEPLOY_BRANCH

# Build things here
./scripts/ci/build

# Configure details
git config user.email "$USER_EMAIL"
git config user.name "$USER_NAME"

# Add, commit and push built files
git add -fA
git commit --allow-empty -m "Deploy $commit"
git push -f origin $DEPLOY_BRANCH

git checkout $SOURCE_BRANCH

echo "Deploy successful"

exit 0
