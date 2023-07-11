module Slim
  class Embedded < Filter
    class JavaScriptEngine < TagEngine
      alias_method :original_on_slim_embedded, :on_slim_embedded

      def on_slim_embedded(engine, body, attrs)
        minified_body = minify(body)
        super(engine, [:html, :js, minified_body], attrs)
      end

      private

      def minify(body)
        multiline_comment = false
        body.filter do |line|
          if line.instance_of?(Array) && line.first == :slim
            if line.last.match?(/\A\/\*/)
              multiline_comment = true
              next false
            elsif multiline_comment
              multiline_comment = false if line.last.match?(/\*\//)
              next false
            end
            !line.last.match?(/\A\/\//)
          else
            true
          end
        end
      end
    end
  end
end
