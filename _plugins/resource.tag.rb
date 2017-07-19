###
# Liquid tag that returns the URL of a resource
#
# Usage:
#   {% resource <title, general resource> %}
#   {% resource <subclub>/<title> %}
#
# E.g.:
#   {% resource beginner/hello-world.cpp %}
#     => /resources/beginner/hello-world.cpp
#
#   {% resource use-cccgrader %}
#     => /resources/general/use-cccgrader/
###
module Jekyll
  class ResourceTag < Liquid::Tag
    def initialize(tag_name, text, tokens)
      super
      @subclub = text.strip.split('/')[0]
      @resource = text.strip.split('/')[1]

      if @resource.nil?
        @resource = @subclub
        @subclub = 'general'
      end
    end

    def render(context)
      # Check if subclub folder exists, raise a name error if it doesn't
      Dir.chdir(File.join(context.registers[:site].source, '_resources')) do
        if !Dir.exist?(@subclub)
          raise NameError.new("Subclub folder #{@subclub} wasn't found")
        end
      end

      # Check resources in subclub
      Dir.chdir(File.join(context.registers[:site].source, '_resources',
          @subclub)) do
        resources = Dir[@resource + '*'].reject { |x| File.symlink?(x) }

        if resources.size > 0
          if File.extname(resources[0]) == '.md' ||
              File.extname(resources[0]) == '.adoc'
            resources[0] = File.basename(resources[0], '.*') + '/'
          end

          "/resources/#{@subclub}/#{resources[0]}"
        else
          raise NameError.new("Resource #{@subclub}/#{@resource} wasn't found.")
        end
      end
    end
  end
end

Liquid::Template.register_tag('resource', Jekyll::ResourceTag)
