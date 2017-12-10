#!/usr/bin/env bash

# Exit if any subcommand fails
set -e

echo "Starting setup"

# Install rsync (needed for build)
sudo apt-get install -y rsync

# Ignore file mode changes
git config core.fileMode false

# Update submodules, if required
git submodule update --init

# Set up Ruby dependencies
gem install bundler:1.15.3 --conservative
bundle check --path $BUNDLE_INSTALL_DIR || \
  bundle install --path $BUNDLE_INSTALL_DIR

echo "Setup successful"

exit 0
