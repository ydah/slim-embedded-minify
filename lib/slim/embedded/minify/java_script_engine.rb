# frozen_string_literal: true

module Slim
  class Embedded < Filter
    class JavaScriptEngine < TagEngine
      alias orig_js_on_slim_embedded on_slim_embedded

      def on_slim_embedded(engine, body, attrs)
        minified_body = minify(body)
        orig_js_on_slim_embedded(engine, minified_body, attrs)
      end

      private

      def remove_comments!(line)
        line.last.gsub!(/((?<!['"])\/\*[^*\/]*\*\/?(?<!['"]))/, '')
        line.last.gsub!(/((?<!['"])\/\/.*[^'"]+)/, '')
      end
    end
  end
end
