# frozen_string_literal: true

module Slim
  class Embedded < Filter
    module Minify
      # Minify embedded tag code in Slim templates.
      module Tag
        def on_slim_embedded(engine, body, attrs)
          body = minify(body) if engine == :css
          super(engine, body, attrs)
        end

        private

        def minify(body)
          multiline_comment = false
          body.filter_map do |line|
            if line.instance_of?(Array) && line.first == :slim
              remove_comments!(line)
              next if line.last.nil?

              remove_whitespace!(line)
              stripped_quotes = stripped_quotes(line)
              if stripped_quotes.include?("/*") && !multiline_comment
                multiline_comment = true
                line[-1] = line.last.reverse.sub(%r{.*?\*/}, "").reverse
              elsif multiline_comment
                next unless stripped_quotes.include?("*/")

                multiline_comment = false
                line.last.sub!(%r{.*\*/(?<!['"])}, "")
              end
              if stripped_quotes.include?("/*") && !multiline_comment
                multiline_comment = true
                line[-1] = line.last.reverse.sub(%r{.*?\*/}, "").reverse
              end
              next if empty_line?(line)
            end
            line
          end
        end

        def remove_comments!(line)
          need_deletion = false
          escaped = false
          escaped_backslash = false
          inside_char = nil
          line[-1] = line.last.chars.each_with_index.map do |char, index|

            if char == "/" && next_char(line, index) == "*" && inside_char.nil?
              if remaining_string_range(line, index).include?("*/")
                need_deletion = true
                next
              end
            elsif char == "/" && prev_char(line, index) == "*" && inside_char.nil? && need_deletion
              need_deletion = false
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

        def remaining_string_range(line, index)
          line.last[index..]
        end

        def prev_char(line, index)
          line.last[index - 1] if index.positive?
        end

        def next_char(line, index)
          line.last[index + 1]
        end

        def remove_whitespace!(line)
          return unless line.last.delete("\n").match?(/^\s*$/)

          line.last.gsub!(/^\s*$/, "")
        end

        def stripped_quotes(line)
          inside_char = nil
          escaped = false
          escaped_backslash = false
          line.last.chars.each_with_index.filter_map do |char, index|
            if ["'", '"'].include?(char) && inside_char.nil?
              inside_char = char
              next
            elsif char == "\\" && next_char(line, index) == "\\" && inside_char
              escaped_backslash = true
              next
            elsif char == "\\"
              if ["'",
                  '"'].include?(next_char(line, index)) && inside_char == next_char(line, index) && !escaped_backslash
                escaped = true
              end
              escaped_backslash = false
              next
            elsif char == inside_char && !inside_char.nil?
              inside_char = nil unless escaped
              escaped = false
              next
            elsif inside_char
              next
            else
              char
            end
          end.join
        end

        def empty_line?(line)
          line.last.gsub(/[\n\s]/, "").empty?
        end
      end
    end
  end
end
