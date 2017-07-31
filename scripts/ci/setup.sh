#!/usr/bin/env sh

# Exit if any subcommand fails
set -e

echo "Starting setup"

# Ignore file mode changes
git config core.fileMode false

# Update submodules, if required
git submodule update --init

# Set up Ruby dependencies
gem install bundler --conservative
bundle check --path $BUNDLE_INSTALL_DIR || \
  bundle install --path $BUNDLE_INSTALL_DIR

# Patch Jekyll Asciidoc
# There's an issue where defining the category property on a page means that
# that page loses its category property
# See https://github.com/asciidoctor/jekyll-asciidoc/pull/160 for patch
jekyll_asciidoc_path=`bundle show "jekyll-asciidoc"`
if [ `echo $jekyll_asciidoc_path | grep '[0-2]\(\.[0-9]\+\)\+$'` ]; then
  jekyll_asciidoc_path=jekyll_asciidoc_path/lib/jekyll-asciidoc/integrator.rb
  sed -i.bak "s/data\.delete sole_key/data[sole_key]/" $jekyll_asciidoc_path
fi

echo "Setup successful"

exit 0

