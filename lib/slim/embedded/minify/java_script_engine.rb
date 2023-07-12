# frozen_string_literal: true

module Slim
  class Embedded < Filter
    class JavaScriptEngine < TagEngine
      alias original_on_slim_embedded on_slim_embedded

      def on_slim_embedded(engine, body, attrs)
        minified_body = minify(body)
        super(engine, [:html, :js, minified_body], attrs)
      end

      private

      def minify(body)
        multiline_comment = false
        body.map do |line|
          if line.instance_of?(Array) && line.first == :slim
            remove_comments!(line)
            remove_whitespace!(line)

            if line.last.match?(%r{/\*})
              multiline_comment = true
              next
            elsif multiline_comment
              multiline_comment = false if line.last.match?(%r{\*/})
              next
            end
            line
          else
            line
          end
        end.compact
      end

      def remove_comments!(line)
        line.last.gsub!(/\/\*.*?\*\//, '')
        line.last.gsub!(/\/\/.*$/, '')
      end

      def remove_whitespace!(line)
        if line.last.gsub(/\n/, '').match?(/^\s*$/)
          line.last.gsub!(/^\s*$/, '')
        end
      end
    end
  end
end
