###
# Liquid tag that returns the URL of a lesson
#
# Usage:
#   {% lesson <subclub>/<title> %}
#
# E.g.:
#   {% lesson beginner/lesson-01 %}
#   {% lesson beginner/starting-off %}
#   {% lesson beginner/lesson-01-starting-off %}
#     => /lessons/beginner/lesson-01-starting-off/
###
module Jekyll
  class LessonTag < Liquid::Tag
    def initialize(tag_name, text, tokens)
      super
      @subclub = text.strip.split('/')[0]
      @lesson = text.strip.split('/')[1]
    end

    def render(context)
      # Check if subclub folder exists, raise a name error if it doesn't
      Dir.chdir(File.join(context.registers[:site].source, '_lessons')) do
        if !Dir.exist?(@subclub)
          raise NameError.new("Subclub folder #{@subclub} wasn't found")
        end
      end

      # Check lessons
      Dir.chdir(File.join(context.registers[:site].source, '_lessons',
          @subclub)) do
        pattern = case @lesson
          when /lesson-\d\d-.+/ then "#{@lesson}*"
          when /lesson-\d\d/    then "#{@lesson}-*"
          else                       "lesson-[0-9][0-9]-#{@lesson}*"
        end
        lessons = Dir[pattern].reject { |x| File.symlink?(x) }

        if lessons.size > 0
          if File.extname(lessons[0]) == '.md' ||
              File.extname(lessons[0]) == '.adoc'
            lessons[0] = File.basename(lessons[0], '.*') + '/'
          elsif Dir.exist?(lessons[0])
            lessons[0] += '/'
          end

          "/lessons/#{@subclub}/#{lessons[0]}"
        else
          raise NameError.new("Lesson #{@subclub}/#{@lesson} wasn't found.")
        end
      end
    end
  end
end

Liquid::Template.register_tag('lesson', Jekyll::LessonTag)
