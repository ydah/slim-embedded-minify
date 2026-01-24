# frozen_string_literal: true

require "minitest/autorun"
require_relative "../lib/slim/embedded/minify"

class TestSlim < Minitest::Test
  def render(source, options = {}, &block)
    scope = options.delete(:scope)
    locals = options.delete(:locals)
    Slim::Template.new(options[:file], options) { source }.render(scope || @env, locals, &block)
  end

  def assert_html(expected, source, options = {}, &block)
    assert_equal expected, render(source, options, &block)
  end

  def gem_available?(name)
    Gem::Specification.find_by_name(name)
    true
  rescue Gem::LoadError
    false
  end

  def sass_available?
    return true if defined?(::Sass)

    %w[sass-embedded sassc sass].any? { |name| gem_available?(name) }
  end

  def less_available?
    gem_available?("less")
  end

  def coffee_available?
    gem_available?("coffee-script")
  end
end
