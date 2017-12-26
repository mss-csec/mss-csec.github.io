#!/usr/bin/env ruby

# Add height="16" attributes to all FontAwesome SVG icons
# http://www.otsukare.info/2017/11/02/fatwigoo

require 'nokogiri'

Dir["fontawesome-5.0.2/raw-svg/**/*.svg"].each do |path|
  formatted = ""
  new_path = path.sub /raw-svg\/\w+/, 'formatted-svg'

  if File.exist? path.sub(/\/\w+\//, '/regular/') and path.split('/')[-2] == 'solid'
    new_path.sub! /[\w-]+\.svg/ do |s| 'solid-' + s end
  end

  File.open path, 'r' do |fstream|
    doc = Nokogiri::XML fstream, &:noblanks
    doc.child[:height] = 16
    formatted = doc.child.to_xml :indent => 0
  end
  File.write new_path, formatted.gsub(/\n/, '') + "\n"
end
