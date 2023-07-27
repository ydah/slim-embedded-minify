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
              next if line.last.nil?

              remove_whitespace!(line)
              stripped_quotes = stripped_quotes(line)
              if stripped_quotes.match?(%r{/\*}) && !multiline_comment
                multiline_comment = true
                line[-1] = line.last.reverse.sub(/.*?\*\//, '').reverse
              elsif multiline_comment
                next unless stripped_quotes.match?(%r{\*/})

                multiline_comment = false
                line.last.sub!(/.*\*\/(?<!['"])/, '')
              end
              if stripped_quotes.match?(%r{/\*}) && !multiline_comment
                multiline_comment = true
                line[-1] = line.last.reverse.sub(/.*?\*\//, '').reverse
              end
              next if empty_line?(line)
            end
            line
          end.compact
        end

        def minify_multiple_comments!(line)
        end

        def remove_comments!(line)
          need_deletion = false
          inside_char = nil
          line[-1] = line.last.chars.each_with_index.map do |char, index|
            if char == '/' && next_char(line, index) == '*' && inside_char.nil?
              if remaining_string_range(line, index).match?(/\*\//)
                need_deletion = true
                next
              end
            elsif char == '/' && prev_char(line, index) == '*' && inside_char.nil? && need_deletion
              need_deletion = false
              next
            elsif char == '"' && !need_deletion
              if inside_char == '"'
                inside_char = nil
                next char
              end

              inside_char = '"' if inside_char.nil?
            elsif char == "'" && !need_deletion
              if inside_char == "'"
                inside_char = nil
                next char
              end

              inside_char = "'" if inside_char.nil?
            end
            char unless need_deletion
          end&.compact&.join
        end

        def remaining_string_range(line, index)
          line.last[index..-1]
        end

        def prev_char(line, index)
          line.last[index - 1]
        end

        def next_char(line, index)
          line.last[index + 1]
        end

        def remove_whitespace!(line)
          if line.last.gsub(/\n/, '').match?(/^\s*$/)
            line.last.gsub!(/^\s*$/, '')
          end
        end

        def stripped_quotes(line)
          line.last.gsub(/(['"]).*?\1/, '')
        end

        def empty_line?(line)
          line.last.gsub(/[\n\s]/, '').empty?
        end
      end
    end
  end
end
