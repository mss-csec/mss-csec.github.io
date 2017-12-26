#!/usr/bin/env ruby

# Add height="16" attributes to all FontAwesome SVG icons
# http://www.otsukare.info/2017/11/02/fatwigoo

require 'nokogiri'

Dir["fontawesome-5.0.2/raw-svg/**/*.svg"].each do |path|
  formatted = ""
  class_name = path.split('/')[-1][0..-5]
  new_path = path.sub /raw-svg\/\w+/, 'formatted-svg'

  if File.exist? path.sub(/\/\w+\//, '/regular/') and path.split('/')[-2] == 'solid'
    class_name = 'solid-' + class_name
    new_path.sub! /[\w-]+\.svg/, class_name + '.svg'
  end

  File.open path, 'r' do |fstream|
    doc = Nokogiri::XML fstream, &:noblanks
    doc.child[:height] = 16
    doc.child[:class] = 'icon icon-' + class_name
    formatted = doc.child.to_xml :indent => 0
  end
  File.write new_path, formatted.gsub(/\n/, '') + "\n"
end
