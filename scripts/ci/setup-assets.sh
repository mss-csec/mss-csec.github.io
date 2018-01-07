#!/usr/bin/env bash

# Exit if any subcommand fails
set -e

echo "Starting setup"

# Ignore file mode changes
git config core.fileMode false

# Set up npm
npm install

echo "Setup successful"

exit 0
