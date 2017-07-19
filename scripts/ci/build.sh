#!/usr/bin/env sh

# Exit if any subcommand fails
set -e

echo "Starting build"

# Normalize file structure
# /_subclubs/:subclub/lessons/:lesson/:permatitle.md
# /_subclubs/:subclub/lessons/:lesson/hero.jpg
#   --> /_lessons/:subclub/:lesson-:permatitle/index.md
#   --> /_lessons/:subclub/:lesson-:permatitle/hero.jpg
for orig_dir in `ls -d _subclubs/**/lessons/`; do
  for orig_path in `find $orig_dir -name '*.md' -o -name '*.adoc'`; do
    subclub=`echo $orig_path | cut -d'/' -f2`
    week=`   echo $orig_path | cut -d'/' -f4`
    title=`  echo $orig_path | cut -d'/' -f5 | sed -r "s/(.+)\..+/\1/"`

    # Perform some sanity checks
    if [ "$subclub" = "lessons" ] || [ "$subclub" = "_subclubs" ] ||
        [ "$week" = "lessons" ]; then
      echo "ERROR: Pattern matching picked up the wrong patterns!"
      echo "Full path: $orig_path"
      echo "Patterns:"
      echo "  subclub => $subclub"
      echo "  week    => $week"
      echo "  title   => $title"
      exit 1;
    fi

    # Make directories if nonexistent
    if [ ! -d "_lessons" ]; then mkdir "_lessons"; fi
    if [ ! -d "_lessons/${subclub}" ]; then mkdir "_lessons/$subclub"; fi

    # Remove lesson directory if existent
    if [ -d "_lessons/${subclub}/${week}-${title}" ]; then
      rm -r "_lessons/$subclub/$week-$title"
    fi

    mkdir "_lessons/$subclub/$week-$title"

    # Copy over original lesson file
    cp $orig_path "_lessons/$subclub/$week-$title/index.md"

    # Move over other files
    cp -r "$(echo $orig_path | cut -d'/' -f-4)/"* \
      "_lessons/$subclub/$week-$title/"

    # Remove duplicated lesson file
    rm "_lessons/$subclub/$week-$title/$title.md"
  done
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

