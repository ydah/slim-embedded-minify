# frozen_string_literal: true

require_relative "../../test_helper"

class MinifyTagUnitTest < Minitest::Test
  class DummyTagBase
    def on_slim_embedded(engine, body, attrs)
      [engine, body, attrs]
    end
  end

  class DummyTag < DummyTagBase
    prepend Slim::Embedded::Minify::Tag
  end

  def test_on_slim_embedded_minifies_css_engines
    dummy = DummyTag.new
    body = body_with("/* comment */", "color: blue;")
    result = dummy.on_slim_embedded(:scss, body, {})

    assert_equal :scss, result[0]
    assert_equal ["color: blue;\n"], result[1].map(&:last)
    assert_equal({}, result[2])
  end

  def test_on_slim_embedded_does_not_minify_non_css_engines
    dummy = DummyTag.new
    body = body_with("/* comment */", "color: blue;")
    result = dummy.on_slim_embedded(:markdown, body, {})

    assert_equal :markdown, result[0]
    assert_same body, result[1]
    assert_equal({}, result[2])
  end

  def test_minify_removes_block_comments_and_blank_lines
    dummy = Slim::Embedded::Minify::Tag
    body = body_with("/* comment */", "color: blue;", "", "  ")
    result = dummy_method(dummy, :minify, body)

    assert_equal ["color: blue;\n"], result.map(&:last)
  end

  def test_minify_preserves_comment_markers_in_quotes
    dummy = Slim::Embedded::Minify::Tag
    body = body_with('font-family: "/*foo*/"; /* comment */')
    result = dummy_method(dummy, :minify, body).map(&:last).join

    assert_match(/font-family: "\/\*foo\*\/";/, result)
    refute_match(/comment/, result)
  end

  private

  def body_with(*lines)
    lines.map { |line| [:slim, :text, "#{line}\n"] }
  end

  def dummy_method(mod, name, *args)
    klass = Class.new { include mod }
    klass.new.send(name, *args)
  end
end

class MinifyJavascriptUnitTest < Minitest::Test
  def test_minify_removes_line_comments
    body = body_with("var a = 1; // comment", "alert('// ok')")
    result = dummy_method(Slim::Embedded::Minify::Javascript, :minify, body).map(&:last).join

    assert_match(/var a = 1;/, result)
    refute_match(/comment/, result)
    assert_match(/alert\('\/\/ ok'\)/, result)
  end

  def test_minify_removes_block_comments
    body = body_with("/* comment */", "alert('hi')")
    result = dummy_method(Slim::Embedded::Minify::Javascript, :minify, body).map(&:last).join

    refute_match(/comment/, result)
    assert_match(/alert\('hi'\)/, result)
  end

  private

  def body_with(*lines)
    lines.map { |line| [:slim, :text, "#{line}\n"] }
  end

  def dummy_method(mod, name, *args)
    klass = Class.new { include mod }
    klass.new.send(name, *args)
  end
end
