# frozen_string_literal: true

module Slim
  class Embedded < Filter
    module Minify
      module Tag
        def on_slim_embedded(engine, body, attrs)
          body = minify(body) if engine == :css
          super(engine, body, attrs)
        end

        private

        def minify(body)
          multiline_comment = false
          body.map do |line|
            if line.instance_of?(Array) && line.first == :slim
              remove_comments!(line)
              remove_whitespace!(line)

              stripped_quotes = stripped_quotes(line)
              if stripped_quotes.match?(%r{/\*})
                multiline_comment = true
                next
              elsif multiline_comment
                multiline_comment = false if stripped_quotes.match?(%r{\*/})
                next
              end
              line
            else
              line
            end
          end.compact
        end

        def remove_comments!(line)
          line.last.gsub!(/((?<!['"])\/\*[^*\/]*\*\/?(?<!['"]))/, '')
        end

        def remove_whitespace!(line)
          if line.last.gsub(/\n/, '').match?(/^\s*$/)
            line.last.gsub!(/^\s*$/, '')
          end
        end

        def stripped_quotes(line)
          line.last.gsub(/(['"]).*?\1/, '')
        end
      end
    end
  end
end
