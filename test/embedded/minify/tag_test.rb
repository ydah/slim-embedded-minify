# frozen_string_literal: true

require_relative "../../test_helper"

class TagTest < TestSlim
  def test_render_with_css
    source = %q{
css:
  h1 { color: blue }
}
  assert_html "<style>h1 { color: blue }</style>", source
  end

  def test_render_with_css_empty_attributes
    source = %q{
css []:
  h1 { color: blue }
}
  assert_html "<style>h1 { color: blue }</style>", source
  end

  def test_render_with_css_attribute
    source = %q{
css scoped = "true":
  h1 { color: blue }
}
  assert_html "<style scoped=\"true\">h1 { color: blue }</style>", source
  end

  def test_render_with_css_multiple_attributes
    source = %q{
css class="myClass" scoped = "true" :
  h1 { color: blue }
}
  assert_html "<style class=\"myClass\" scoped=\"true\">h1 { color: blue }</style>", source
  end

  def test_render_with_css_and_comment
    source = %q{
css:
  /* comment */
  h1 {
    /* comment */font-family: "/*foo*/", '/*bar*/';/* comment */
    color: blue;
    /* comment */
  }
}
  assert_html "<style>\nh1 {\n  font-family: \"/*foo*/\", '/*bar*/';\n  color: blue;\n}</style>", source
  end

  def test_render_with_css_and_multiple_comment
    source = %q{
css:
  /*
    multiline
    comment
  */
  h1 {
    color: blue;
    /*
      multiline
      comment
    */
  }
}
  assert_html "<style>\nh1 {\n  color: blue;\n}</style>", source
  end
end
