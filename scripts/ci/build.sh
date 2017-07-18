#!/usr/bin/env sh

# Exit if any subcommand fails
set -e

echo "Starting build"

# Normalize file structure
# /_subclubs/:subclub/lessons/:lesson/:permatitle.md
#   --> /_lessons/:subclub/:lesson-:permatitle.md
for orig_path in `ls _subclubs/**/lessons/**/*.md`; do
  subclub=`echo $orig_path | cut -d'/' -f2`
  week=`   echo $orig_path | cut -d'/' -f4`
  title=`  echo $orig_path | cut -d'/' -f5`

  if [ ! -d "_lessons" ]; then mkdir "_lessons"; fi
  if [ ! -d "_lessons/${subclub}" ]; then mkdir "_lessons/$subclub"; fi

  cp $orig_path "_lessons/$subclub/$week-$title"
done
# /_subclubs/:subclub/resources
#   --> /_resources/:subclub/
# LOW PRIORITY

# Build site
bundle exec jekyll build --config _config.yml,_config-prod.yml

# Delete and move files
find . -maxdepth 1 ! -name '.git' ! -name '.gitignore' ! -name '_site' \
    ! -name '.circleci' ! -name '.vagrant' -exec rm -rf {} \;

mv _site/* .
rm -R _site/

echo "Build successful"

exit 0

