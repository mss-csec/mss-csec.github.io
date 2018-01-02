#!/usr/bin/env bash

# Exit if any subcommand fails
set -e

echo "Starting post-build"

# Delete and move files
find . -maxdepth 1 \
    ! -name '.git' ! -name '.gitignore' ! -name '_site' \
    ! -name 'scripts' ! -name '.circleci' ! -name '.vagrant' \
    -exec rm -rf {} \;

mv _site/* .
rm -R _site/

touch .nojekyll

echo "Post-build successful"

exit 0
