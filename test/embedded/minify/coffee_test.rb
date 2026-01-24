# frozen_string_literal: true

require_relative "../../test_helper"

class CoffeeTest < TestSlim
  def test_render_with_coffee_and_comment
    source = <<~SLIM
      coffee:
        # CoffeeScript comment (becomes JS comment after compilation)
        square = (x) -> x * x
        alert square(5)
    SLIM
    if coffee_available?
      result = render(source)
      assert_match(/<script>/, result)
      assert_match(/square/, result)
    else
      assert_raises(LoadError) { render(source) }
    end
  end
end
