# frozen_string_literal: true

require_relative "../../test_helper"

class LessTest < TestSlim
  def test_render_with_less_and_comment
    source = <<~SLIM
      less:
        /* comment */
        @color: blue;
        body { color: @color; }
    SLIM
    if less_available?
      result = render(source)
      refute_match(%r{/\*.*comment.*\*/}, result)
      assert_match(/color:\s*blue/, result)
    else
      assert_raises(Temple::FilterError, LoadError) { render(source) }
    end
  end
end
