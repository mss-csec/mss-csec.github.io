#!/usr/bin/env bash

source $HOME/.nvm/nvm.sh

nvm install $1
nvm alias default $1

shift

if (( $# )); then
  npm install -g $@
fi
