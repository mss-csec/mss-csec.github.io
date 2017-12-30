#!/usr/bin/env bash

# Exit if any subcommand fails
set -e

echo "Starting pre-build"

# Delete previous build & deploy branches, if they exist
# Necessary given caching
if [ `git branch | grep $BUILD_BRANCH` ]; then
  git branch -D $BUILD_BRANCH
fi

if [ `git branch | grep $DEPLOY_BRANCH` ]; then
  git branch -D $DEPLOY_BRANCH
fi

# Sometimes, Gemfile.lock gets modified in setup. So we stash it to make sure
# it doesn't interfere with git
echo "Stashing modified files..."
git stash save

# Track the deploy branch, or assign it as the build branch if it doesn't exist
git fetch
if [ `git ls-remote --heads $CIRCLE_REPOSITORY_URL $DEPLOY_BRANCH | wc -l` ]; then
  git checkout $DEPLOY_BRANCH
else
  BUILD_BRANCH=$DEPLOY_BRANCH
fi

git checkout $SOURCE_BRANCH

# Create the build branch as an orphan
git checkout --orphan $BUILD_BRANCH

# Restore stash
echo "Restoring stash..."
git stash pop || true

# Update submodules to their remotes
git submodule update --remote

echo "Pre-build successful"

exit 0
