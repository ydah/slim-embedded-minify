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

        def remove_comments!(line)
          need_deletion = false
          need_deletion_all = false
          escaped = false
          escaped_backslash = false
          inside_char = nil
          line[-1] = line.last.chars.each_with_index.map do |char, index|
            next if need_deletion_all

            if char == "/" && next_char(line, index) == "*" && inside_char.nil?
              if remaining_string_range(line, index).include?("*/")
                need_deletion = true
                next
              end
            elsif char == "/" && prev_char(line, index) == "*" && inside_char.nil? && need_deletion
              need_deletion = false
              next
            elsif char == "/" && next_char(line, index) == "/" && inside_char.nil? && !need_deletion
              need_deletion_all = true
              next
            elsif char == "\\" && next_char(line, index) == "\\" && inside_char
              escaped_backslash = true
              next char
            elsif char == "\\"
              if ["'", '"'].include?(next_char(line, index)) && inside_char == next_char(line, index) && !escaped_backslash
                escaped = true
              end
              escaped_backslash = false
              next char
            elsif ["'", '"'].include?(char) && !need_deletion
              if inside_char == char
                inside_char = nil unless escaped
                escaped = false
                next char
              end

              inside_char = char if inside_char.nil?
            end
            char if !need_deletion || inside_char
          end&.compact&.join
        end
      end
    end
  end
end
