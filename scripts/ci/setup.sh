#!/usr/bin/env sh

# Exit if any subcommand fails
set -e

echo "Starting setup"

# Checkout the correct branch
git checkout $SOURCE_BRANCH

# Update submodules, if required
git submodule update --init

# Set up Ruby dependencies
gem install bundler --conservative
bundle check || bundle install
bundle update

echo "Setup successful"

exit 0

