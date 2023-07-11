require 'minitest/autorun'
require_relative '../lib/slim/embedded/minify'

class TestSlim < Minitest::Test
  def render(source, options = {}, &block)
    scope = options.delete(:scope)
    locals = options.delete(:locals)
    Slim::Template.new(options[:file], options) { source }.render(scope || @env, locals, &block)
  end

  def assert_html(expected, source, options = {}, &block)
    assert_equal expected, render(source, options, &block)
  end
end
