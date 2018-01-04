source "https://rubygems.org"

# Hello! This is where you manage which Jekyll version is used to run.
# When you want to use a different version, change it below, save the
# file and run `bundle install`. Run Jekyll with `bundle exec`, like so:
#
#     bundle exec jekyll serve
#
# This will help ensure the proper Jekyll version is running.
# Happy Jekylling!
gem "jekyll", "3.6.0" # Keep with GitHub Pages
                      # EDIT 2017-09-24: Update to 3.6.0 ahead of GH (which uses 3.5.2) due to
                      # asciidoctor-rouge requiring Rouge 2

# 2017-10-14: Apply expedited fix for rouge/#796
gem "rouge", :git => "https://github.com/tyxchen/rouge.git", :ref => "locked-at-v2.2.1"

# If you want to use GitHub Pages, remove the "gem "jekyll"" above and
# uncomment the line below. To upgrade, run `bundle update github-pages`.
# gem "github-pages", group: :jekyll_plugins

# If you have any plugins, put them here!
group :jekyll_plugins do
  # Add AsciiDoc as a compatible syntax
  # 2017-10-14: Apply expedited patch for jekyll-asciidoc/#160
  gem "jekyll-asciidoc", :git => "https://github.com/asciidoctor/jekyll-asciidoc.git", :ref => "92b8691"

  # Use Rouge for Asciidoctor highlighting
  gem "asciidoctor-rouge"

  # Use Jekyll Compose
  gem "jekyll-compose"

  # Create a RSS feed
  gem "jekyll-feed", "~> 0.6"

  # Add jekyll SEO
  gem "jekyll-seo-tag"

  # Add sitemap
  gem "jekyll-sitemap"
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

###
# END JEKYLL CONFIG
###
