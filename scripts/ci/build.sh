#!/usr/bin/env bash

# Exit if any subcommand fails
set -e

lessons_dir='_lessons'
resources_dir='_resources'
subclubs_dir='_subclubs'

asset_commit=`git ls-remote ${CIRCLE_REPOSITORY_URL} refs/heads/${ASSETS_BRANCH} | cut -f1`

echo "Starting build"
echo

# Make directories if nonexistent
if [ ! -d "$lessons_dir" ]; then
  echo "Making \`$lessons_dir/' directory"
  mkdir "$lessons_dir";
fi

if [ ! -d "$resources_dir" ]; then
  echo "Making \`$resources_dir/' directory"
  mkdir "$resources_dir";
fi

# Normalize file structure
# /_subclubs/:subclub/<dir>/*
#   --> /_<dir>/:subclub/*

for subclub_subdir in `echo _subclubs/*/*/`; do
  subclub=`echo $subclub_subdir | cut -d'/' -f2`
  subdir=`echo $subclub_subdir | cut -d'/' -f3`

  # Perform some sanity checks
  if [ "$subclub" = "$subclubs_dir" ] || [ "$subclub" = "$subdir" ]; then
    echo "ERROR: Pattern matching picked up the wrong patterns!"
    echo "Full path: $subclub_subdir/"
    echo "Patterns:"
    echo "  subclub => $subclub"
    echo "  subdir  => $subdir"
    exit 1;
  fi

  echo "$subclub/$subdir:"

  dir_diff=`diff -qrx '_*' "$subclub_subdir" "_$subdir/$subclub" &2> /dev/null`

  if [ -z "$dir_diff" ] && [ -d "_$subdir/$subclub" ]; then
    echo "No change, skipping directory."
    continue
  elif [ -d "_$subdir/$subclub" ]; then
    echo $dir_diff
  fi

  rsync -rc --delete --exclude='_*' "$subclub_subdir" "_$subdir/$subclub"

  # Only delete original files in a production environment
  if [ "$1" = "production" ]; then
    echo "Removing \`$subclub_subdir' directory"
    rm -r ${subclub_subdir%%/}
  fi
done

echo

# Build site
if [ "$1" != "production" ]; then
  bundle exec jekyll build  # Jekyll
else
  echo "production: true" \
    >> _config-prod.yml
  echo "build_url: /commit/$CIRCLE_SHA1" \
    >> _config-prod.yml
  echo "build_version: $(echo $CIRCLE_SHA1 | cut -c-7)" \
    >> _config-prod.yml
  echo "cdn_url: /cdn-assets" \
    >> _config-prod.yml

  bundle exec jekyll build --config _config.yml,_config-prod.yml  # Jekyll
fi

echo "Build successful"

exit 0
