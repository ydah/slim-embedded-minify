# frozen_string_literal: true

require_relative "../../test_helper"

class TagTest < TestSlim
  def test_render_with_css
    source = <<~SLIM
      css:
        h1 { color: blue }
    SLIM
    assert_html "<style>h1 { color: blue }</style>", source
  end

  def test_render_with_css_empty_attributes
    source = <<~SLIM
      css []:
        h1 { color: blue }
    SLIM
    assert_html "<style>h1 { color: blue }</style>", source
  end

  def test_render_with_css_attribute
    source = <<~SLIM
      css scoped = "true":
        h1 { color: blue }
    SLIM
    assert_html %{<style scoped="true">h1 { color: blue }</style>}, source
  end

  def test_render_with_css_multiple_attributes
    source = <<~SLIM
      css class="myClass" scoped = "true" :
        h1 { color: blue }
    SLIM
    assert_html %{<style class="myClass" scoped="true">h1 { color: blue }</style>}, source
  end

  def test_render_with_css_and_comment
    source = <<~SLIM
      css:
        /* comment */
        h1 {
          /* comment * / */font-family: "/*foo*/", '/*bar*/';/** /comment */
          color: blue;
          /* comment */
        }
    SLIM
    assert_html <<~HTML.chomp, source
      <style>
      h1 {
        font-family: "/*foo*/", '/*bar*/';
        color: blue;
      }</style>
    HTML
  end

  def test_render_with_css_and_multiple_comment
    source = <<~SLIM
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
    SLIM
    assert_html <<~HTML.chomp, source
      <style>
      h1 {
        color: blue;
      }</style>
    HTML
  end
end
