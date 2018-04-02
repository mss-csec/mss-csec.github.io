#!/usr/bin/env bash

set -e

source $HOME/.nvm/nvm.sh

cd /vagrant
bundle install
npm install
cd -
