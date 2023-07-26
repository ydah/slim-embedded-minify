# frozen_string_literal: true

require_relative "../../test_helper"

class JavascriptTest < TestSlim
  def test_render_with_javascript
    source = <<~SLIM
      javascript:
        $(function() {});


        alert('hello')
      p Hi
    SLIM
    assert_html <<~HTML.chomp, source
      <script>$(function() {});
      alert('hello')</script><p>Hi</p>
    HTML
  end

  def test_render_with_javascript_and_comment
    source = <<~SLIM
      javascript:
        // some comment
        $(function() {});// some comment
          // "" or ''
            // '' or ""

        alert('// argument')
      p Hi
    SLIM
    assert_html <<~HTML.chomp, source
      <script>
      $(function() {});
      alert('// argument')</script><p>Hi</p>
    HTML
  end

  def test_render_with_javascript_and_multiline_comment
    source = <<~SLIM
      javascript:
        /*
          multiline
          comment
        */
        $(function() {});


        alert('hello')
      p Hi
    SLIM
    assert_html <<~HTML.chomp, source
      <script>
      $(function() {});
      alert('hello')</script><p>Hi</p>
    HTML
  end

  def test_render_with_javascript_and_singleline_comment
    source = <<~SLIM
      javascript:
        /* comment */
        $(function() {});
          /* ... * comment / */

        /* ... * comment / */alert("/* argument */")/*... * comment /*/
        /* comment */alert("/* argument */")/*comment*/
      p Hi
    SLIM
    assert_html <<~HTML.chomp, source
      <script>
      $(function() {});
      alert(\"/* argument */\")
      alert(\"/* argument */\")</script><p>Hi</p>
    HTML
  end

  def test_render_with_javascript_empty_attributes
    source = <<~SLIM
      javascript ():
        alert('hello')
    SLIM
    assert_html %{<script>alert('hello')</script>}, source
  end

  def test_render_with_javascript_attribute
    source = <<~SLIM
      javascript [class = "myClass"]:
        alert('hello')
    SLIM
    assert_html %{<script class=\"myClass\">alert('hello')</script>}, source
  end

  def test_render_with_javascript_multiple_attributes
    source = <<~SLIM
      javascript { class = "myClass" id="myId" other-attribute = 'my_other_attribute' }  :
        alert('hello')
    SLIM
    assert_html %{<script class=\"myClass\" id=\"myId\" other-attribute=\"my_other_attribute\">alert('hello')</script>},
                source
  end

  def test_render_with_javascript_with_tabs
    source = <<~SLIM
      javascript:
      \t$(function() {});
      \talert('hello')
      p Hi
    SLIM
    assert_html <<~HTML.chomp, source
      <script>$(function() {});
      alert('hello')</script><p>Hi</p>
    HTML
  end

  def test_render_with_javascript_including_variable
    source = <<~'SLIM'
      - func = "alert('hello');"
      javascript:
        $(function() { #{func} });
    SLIM
    assert_html "<script>$(function() { alert(&#39;hello&#39;); });</script>", source
  end

  def test_render_with_javascript_with_explicit_html_comment
    Slim::Engine.with_options(js_wrapper: :comment) do
      source = <<~SLIM
        javascript:
        \t$(function() {});
        \talert('hello')
        p Hi
      SLIM
      assert_html <<~HTML.chomp, source
        <script><!--
        $(function() {});
        alert('hello')
        //--></script><p>Hi</p>
      HTML
    end
  end

  def test_render_with_javascript_with_explicit_cdata_comment
    Slim::Engine.with_options(js_wrapper: :cdata) do
      source = <<~SLIM
        javascript:
        \t$(function() {});
        \talert('hello')
        p Hi
      SLIM
      assert_html <<~HTML.chomp, source
        <script>
        //<![CDATA[
        $(function() {});
        alert('hello')
        //]]>
        </script><p>Hi</p>
      HTML
    end
  end

  def test_render_with_javascript_with_format_xhtml_comment
    Slim::Engine.with_options(js_wrapper: :guess, format: :xhtml) do
      source = <<~SLIM
        javascript:
        \t$(function() {});
        \talert('hello')
        p Hi
      SLIM
      assert_html <<~HTML.chomp, source
        <script>
        //<![CDATA[
        $(function() {});
        alert('hello')
        //]]>
        </script><p>Hi</p>
      HTML
    end
  end

  def test_render_with_javascript_with_format_html_comment
    Slim::Engine.with_options(js_wrapper: :guess, format: :html) do
      source = <<~SLIM
        javascript:
        \t$(function() {});
        \talert('hello')
        p Hi
      SLIM
      assert_html <<~HTML.chomp, source
        <script><!--
        $(function() {});
        alert('hello')
        //--></script><p>Hi</p>
      HTML
    end
  end
end
