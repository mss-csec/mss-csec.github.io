#!/usr/bin/env sh

# Exit if any subcommand fails
set -e

echo "Starting build"

# Build site
bundle exec jekyll build

# Delete and move files
find . -maxdepth 1 ! -name '.git' ! -name '.gitignore' ! -name '_site' ! -name 'circle.yml' -delete

mv _site/* .
rm -R _site/

echo "Build successful"

exit 0

