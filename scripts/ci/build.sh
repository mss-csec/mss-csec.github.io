#!/usr/bin/env sh

# Exit if any subcommand fails
set -e

echo "Starting build"

# Hackishly modify _config.yml for production
# Since we can't change values based on environment, we sed the config instead
# This replaces all key: value pairs flagged with a `prod: <prod value>'
# comment
# e.g.
#   output: true # prod: false
# becomes
#   output: false
sed -Ee 's/(.+:\s*)(.+)#\s*prod\s*:\s*(.+)/\1\3/' _config.yml > _config-prod.yml

# Build site
bundle exec jekyll build --config _config-prod.yml

# Delete and move files
find . -maxdepth 1 ! -name '.git' ! -name '.gitignore' ! -name '_site' \
    ! -name '.circleci' -exec rm -rf {} \;

mv _site/* .
rm -R _site/

echo "Build successful"

exit 0

