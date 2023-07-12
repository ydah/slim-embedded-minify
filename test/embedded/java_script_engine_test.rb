# frozen_string_literal: true

require_relative "../test_helper"

class JavaScriptEngineTest < TestSlim
  def test_render_with_javascript
    source = "
javascript:
  $(function() {});


  alert('hello')
p Hi
"
    assert_html %{<script>$(function() {});\nalert('hello')</script><p>Hi</p>}, source
  end

  def test_render_with_javascript_and_comment
    source = "
javascript:
  // some comment
  $(function() {});// some comment
    // some comment

  alert('hello')
p Hi
"
    assert_html %{<script>\n$(function() {});\nalert('hello')</script><p>Hi</p>}, source
  end

  def test_render_with_javascript_and_multiline_comment
    source = "
javascript:
  /*
    multiline
    comment
  */
  $(function() {});


  alert('hello')
p Hi
"
    assert_html %{<script>\n$(function() {});\nalert('hello')</script><p>Hi</p>}, source
  end

  def test_render_with_javascript_and_singleline_comment
    source = "
javascript:
  /* comment */
  $(function() {});


  /* comment */alert('hello')/* comment */
p Hi
"
    assert_html %{<script>\n$(function() {});\nalert('hello')</script><p>Hi</p>}, source
  end

  def test_render_with_javascript_empty_attributes
    source = "
javascript ():
  alert('hello')
"
    assert_html %{<script>alert('hello')</script>}, source
  end

  def test_render_with_javascript_attribute
    source = %q{
javascript [class = "myClass"]:
  alert('hello')
}
    assert_html %{<script class=\"myClass\">alert('hello')</script>}, source
  end

  def test_render_with_javascript_multiple_attributes
    source = %q{
javascript { class = "myClass" id="myId" other-attribute = 'my_other_attribute' }  :
  alert('hello')
}
    assert_html %{<script class=\"myClass\" id=\"myId\" other-attribute=\"my_other_attribute\">alert('hello')</script>},
                source
  end

  def test_render_with_javascript_with_tabs
    source = "javascript:\n\t$(function() {});\n\talert('hello')\np Hi"
    assert_html "<script>$(function() {});\nalert('hello')</script><p>Hi</p>", source
  end

  def test_render_with_javascript_including_variable
    source = %q{
- func = "alert('hello');"
javascript:
  $(function() { #{func} });
}
    assert_html "<script>$(function() { alert(&#39;hello&#39;); });</script>", source
  end

  def test_render_with_javascript_with_explicit_html_comment
    Slim::Engine.with_options(js_wrapper: :comment) do
      source = "javascript:\n\t$(function() {});\n\talert('hello')\np Hi"
      assert_html "<script><!--\n$(function() {});\nalert('hello')\n//--></script><p>Hi</p>", source
    end
  end

  def test_render_with_javascript_with_explicit_cdata_comment
    Slim::Engine.with_options(js_wrapper: :cdata) do
      source = "javascript:\n\t$(function() {});\n\talert('hello')\np Hi"
      assert_html "<script>\n//<![CDATA[\n$(function() {});\nalert('hello')\n//]]>\n</script><p>Hi</p>", source
    end
  end

  def test_render_with_javascript_with_format_xhtml_comment
    Slim::Engine.with_options(js_wrapper: :guess, format: :xhtml) do
      source = "javascript:\n\t$(function() {});\n\talert('hello')\np Hi"
      assert_html "<script>\n//<![CDATA[\n$(function() {});\nalert('hello')\n//]]>\n</script><p>Hi</p>", source
    end
  end

  def test_render_with_javascript_with_format_html_comment
    Slim::Engine.with_options(js_wrapper: :guess, format: :html) do
      source = "javascript:\n\t$(function() {});\n\talert('hello')\np Hi"
      assert_html "<script><!--\n$(function() {});\nalert('hello')\n//--></script><p>Hi</p>", source
    end
  end
end
