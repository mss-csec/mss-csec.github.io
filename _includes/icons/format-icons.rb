#!/usr/bin/env ruby

# Add height="16" attributes to all FontAwesome SVG icons
# http://www.otsukare.info/2017/11/02/fatwigoo

require 'nokogiri'

Dir["fontawesome-5.0.2/raw-svg/**/*.svg"].each do |path|
  formatted = ""
  icon_name = path.split('/')[-1][0..-5]
  new_path = path.sub /fontawesome-\d\.\d\.\d\/raw-svg\/\w+/, '.'

  if File.exist? path.sub(/\/\w+\//, '/regular/') and path.split('/')[-2] == 'solid'
    icon_name = 'solid-' + icon_name
    new_path.sub! /[\w-]+\.svg/, icon_name + '.svg'
  end

  File.open path, 'r' do |fstream|
    doc = Nokogiri::XML fstream, &:noblanks
    doc.child[:height] = 16
    doc.child[:class] = 'icon icon-' + icon_name
    formatted = doc.child.to_xml :indent => 0
  end
  File.write new_path, formatted.gsub(/\n/, '') + "\n"
end
