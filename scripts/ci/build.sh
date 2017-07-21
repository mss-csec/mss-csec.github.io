#!/usr/bin/env bash

# Exit if any subcommand fails
set -e

echo "Starting build"

# Normalize file structure
# /_subclubs/:subclub/lessons/:permatitle/index.md
# /_subclubs/:subclub/lessons/:permatitle/hero.jpg
#   --> /_lessons/:subclub/:permatitle/index.md
#   --> /_lessons/:subclub/:permatitle/hero.jpg
for orig_path in `ls -d _subclubs/**/lessons/*`; do
  subclub=`echo $orig_path | cut -d'/' -f2`
  title=`  echo $orig_path | cut -d'/' -f4`

  # Perform some sanity checks
  if [ "$subclub" = "lessons" ] || [ "$subclub" = "_subclubs" ] ||
      [ "$title" = "lessons" ]; then
    echo "ERROR: Pattern matching picked up the wrong patterns!"
    echo "Full path: $orig_path/"
    echo "Patterns:"
    echo "  subclub => $subclub"
    echo "  title   => $title"
    exit 1;
  fi

  echo "Found lesson $subclub/$title"

  # Make directories if nonexistent
  if [ ! -d "_lessons" ]; then
    echo "Making \`_lessons/' directory"
    mkdir "_lessons";
  fi

  if [ ! -d "_lessons/${subclub}" ]; then
    echo "Making \`_lessons/$subclub/' directory"
    mkdir "_lessons/$subclub";
  fi

  # Remove lesson directory if existent
  if [ -d "_lessons/${subclub}/${title}" ]; then
    echo "Removing old \`_lessons/$subclub/$title/' directory"
    rm -r "_lessons/$subclub/$title"
  fi

  echo "Making \`_lessons/$subclub/$title/' directory"
  mkdir "_lessons/$subclub/$title"

  # Copy over files
  echo "Copying files from"
  echo "    $orig_path/"
  echo "to"
  echo "    _lessons/$subclub/$title/"
  cp -r "$orig_path/"* \
    "_lessons/$subclub/$title/"

  # Only delete original files in a production environment
  if [ "$1" = "production" ]; then
    echo "Removing \`$orig_path/' directory"
    rm -r "$orig_path"
  fi

  echo
done
# /_subclubs/:subclub/resources
#   --> /_resources/:subclub/
# LOW PRIORITY

# Build site
if [ "$1" != "production" ]; then
  bundle exec jekyll build
else
  echo "build_url: /commit/$CIRCLE_SHA1" \
    >> _config-prod.yml
  echo "build_version: $(date +%Y%m%d)-$(echo $CIRCLE_SHA1 | cut -c-7)" \
    >> _config-prod.yml

  bundle exec jekyll build --config _config.yml,_config-prod.yml

  # Delete and move files
  find . -maxdepth 1 ! -name '.git' ! -name '.gitignore' ! -name '_site' \
      ! -name '.circleci' ! -name '.vagrant' -exec rm -rf {} \;

  mv _site/* .
  rm -R _site/
fi

echo "Build successful"

exit 0

