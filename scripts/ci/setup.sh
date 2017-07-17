#!/usr/bin/env sh

# Exit if any subcommand fails
set -e

echo "Starting setup"

# Update submodules, if required
git submodule update --init

# Set up Ruby dependencies
gem install bundler --conservative
bundle check || bundle install
bundle update

echo "Setup successful"

exit 0

