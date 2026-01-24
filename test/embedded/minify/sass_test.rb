# frozen_string_literal: true

require_relative "../../test_helper"

class SassTest < TestSlim
  def test_render_with_sass_and_comment
    source = <<~SLIM
      sass:
        /* comment */
        $color: blue
        body
          color: $color
    SLIM
    if sass_available?
      result = render(source)
      refute_match(%r{/\*.*comment.*\*/}, result)
      assert_match(/color:\s*blue/, result)
    else
      assert_raises(LoadError, NameError) { render(source) }
    end
  end
end
