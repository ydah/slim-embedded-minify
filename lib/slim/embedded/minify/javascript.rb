# frozen_string_literal: true

module Slim
  class Embedded < Filter
    module Minify
      module Javascript
        include Tag

        def on_slim_embedded(engine, body, attrs)
          minified_body = minify(body)
          super(engine, minified_body, attrs)
        end

        private

        def remove_comments!(line)
          line.last.gsub!(/((?<!['"])\/\*[^*\/]*\*\/?(?<!['"]))/, '')
          line.last.gsub!(/((?<!['"])\/\/.*[^'"]+)/, '')
        end
      end
    end
  end
end
