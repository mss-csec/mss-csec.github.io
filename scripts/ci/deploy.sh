#!/usr/bin/env bash

# Exit if any subcommand fails
set -e

# Automatically resolve conflicts of a deterministic nature
# Trying to rebase the build branch on the deploy branch tends to result in
# conflicts, but thankfully, we know that:
#   (1) the conflicts are between master:HEAD and $commit
#   (2) the changes we want are from $commit
# Thus, for each file with conflicts, we checkout the changes from $commit
# (hence the --theirs flag) and add it to the index.
# Finally, we continue the rebase, which should succeed and leave us with
# a successfully rebased build branch.
__auto_resolve() {
  echo "Automatically resolving conflicts..."
  for file in `git diff --name-only --diff-filter=U`; do
    echo "Checking out $file at $commit..."
    git checkout --theirs -- $file
    git add $file
  done
  git rebase --continue
}

echo "Starting deploy"

# Create a build branch
BUILD_BRANCH="build-$DEPLOY_BRANCH"

# Delete previous build & deploy branches, if they exist
# Necessary given caching
if [ `git branch | grep $BUILD_BRANCH` ]; then
  git branch -D $BUILD_BRANCH
fi

if [ `git branch | grep $DEPLOY_BRANCH` ]; then
  git branch -D $DEPLOY_BRANCH
fi

# Save the previous commit hash for future reference
commit="$(git log -1 --pretty=%h)"

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
git submodule update --recursive --remote

# Build Jekyll
chmod +x ./scripts/ci/build.sh
./scripts/ci/build.sh production

# Add and commit built files
echo "Adding and committing files..."
git add -fA
git commit --allow-empty -m "Deploy $commit"

if [ "$BUILD_BRANCH" != "$DEPLOY_BRANCH" ]; then
  # Checkout the deploy branch and remove all pre-existing files
  git checkout $DEPLOY_BRANCH
  find . -maxdepth 1 ! -name '.git' -exec rm -rf {} \;
  git add -fA
  git commit -m "remove files"

  git checkout $BUILD_BRANCH
  
  # Try --- *TRY* --- to rebase the build branch onto the deploy branch.
  # See documentation of __auto_resolve for details on how conflicts are resolved
  echo "Attempting to rebase $BUILD_BRANCH onto $DEPLOY_BRANCH..."
  git rebase $DEPLOY_BRANCH || __auto_resolve

  # Merge the build commit into the deploy branch
  # Since we rebased the build branch onto the deploy branch, the deploy branch
  # should successfully fast-forward the merged-in commit
  git checkout $DEPLOY_BRANCH
  git merge $BUILD_BRANCH

  # Now, squash the last two commits (removing files, and deploying) into one
  git reset --soft HEAD~2
  git commit --allow-empty -m "Deploy $commit"
fi

# Deploy to GitHub
echo "Deploying to $CIRCLE_REPOSITORY_URL@$DEPLOY_BRANCH..."
git push $CIRCLE_REPOSITORY_URL $DEPLOY_BRANCH

# Cleanup
echo "Cleaning up..."
git checkout $SOURCE_BRANCH
git checkout -- ./scripts/ci/deploy.sh # This script tends to get deleted
git branch -D $BUILD_BRANCH $DEPLOY_BRANCH

echo "Deploy successful"

exit 0
