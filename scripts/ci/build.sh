#!/usr/bin/env bash

# Exit if any subcommand fails
set -e

echo "Starting build"

# Normalize file structure
# /_subclubs/:subclub/lessons/:permatitle/index.md
# /_subclubs/:subclub/lessons/:permatitle/hero.jpg
#   --> /_lessons/:subclub/:permatitle/index.md
#   --> /_lessons/:subclub/:permatitle/hero.jpg
for lesson_path in `ls -d _subclubs/**/lessons/*`; do
  subclub=`echo $lesson_path | cut -d'/' -f2`
  title=`  echo $lesson_path | cut -d'/' -f4`

  # Perform some sanity checks
  if [ "$subclub" = "lessons" ] || [ "$subclub" = "_subclubs" ] ||
      [ "$title" = "lessons" ]; then
    echo "ERROR: Pattern matching picked up the wrong patterns!"
    echo "Full path: $lesson_path/"
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

  if [ ! -d "_lessons/$subclub" ]; then
    echo "Making \`_lessons/$subclub/' directory"
    mkdir "_lessons/$subclub";
  fi

  # Remove lesson directory if existent
  if [ -d "_lessons/$subclub/$title" ]; then
    echo "Removing old \`_lessons/$subclub/$title/' directory"
    rm -r "_lessons/$subclub/$title"
  fi

  if [[ ! "$title" =~ ^_.* ]] && [ ! -z `ls "$lesson_path"` ]; then
    echo "Making \`_lessons/$subclub/$title/' directory"
    mkdir "_lessons/$subclub/$title"

    # Copy over files
    echo "Copying files from"
    echo "    $lesson_path/"
    echo "to"
    echo "    _lessons/$subclub/$title/"
    cp -r "$lesson_path/"* \
      "_lessons/$subclub/$title/"
  else
    echo "Skipping lesson $subclub/$title"
  fi

  # Only delete original files in a production environment
  if [ "$1" = "production" ]; then
    echo "Removing \`$lesson_path/' directory"
    rm -r "$lesson_path"
  fi

  echo
done

# /_subclubs/:subclub/resources
#   --> /_resources/:subclub/
# LOW PRIORITY
for resource_path in `find _subclubs/* -maxdepth 1 -name 'resources' ! -empty`; do
  subclub=`echo $resource_path | cut -d'/' -f2`

  echo "Found resources folder for $subclub"

  # Make directories if nonexistent
  if [ ! -d "_resources" ]; then
    echo "Making \`_resources/' directory"
    mkdir "_resources";
  fi

  if [ ! -d "_resources/$subclub" ]; then
    echo "Making \`_resources/$subclub/' directory"
    mkdir "_resources/$subclub";
  fi

  echo "Copying files from"
  echo "    $resource_path"
  echo "to"
  echo "    _resources/$subclub/"

  cp -r "$resource_path/"* \
    "_resources/$subclub/"
done

# Build site
if [ "$1" != "production" ]; then
  bundle exec jekyll build
else
  echo "production: true" \
    >> _config-prod.yml
  echo "build_url: /commit/$CIRCLE_SHA1" \
    >> _config-prod.yml
  echo "build_version: $(date +%Y%m%d)-$(echo $CIRCLE_SHA1 | cut -c-7)" \
    >> _config-prod.yml

  bundle exec jekyll build --config _config.yml,_config-prod.yml

  # Delete and move files
  find . -maxdepth 1 \
      ! -name '.git' ! -name '.gitignore' ! -name '_site' \
      ! -name '.circleci' ! -name '.vagrant' \
      -exec rm -rf {} \;

  mv _site/* .
  rm -R _site/

  touch .nojekyll
fi

echo "Build successful"

exit 0

