#!/usr/bin/env bash

# Exit if any subcommand fails
set -e

echo "Starting setup"

# Install deb packages needed for build
yes | find ./bin/ -name '*.deb' -exec sudo dpkg -i --force-depends {} \+

# Ignore file mode changes
git config core.fileMode false

# Update submodules, if required
git submodule update --init

# Set up Ruby dependencies
gem install bundler:2.1.4 --conservative
bundle check --path $BUNDLE_INSTALL_DIR || \
  bundle install --path $BUNDLE_INSTALL_DIR

echo "Setup successful"

exit 0
