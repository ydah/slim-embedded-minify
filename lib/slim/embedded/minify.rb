# frozen_string_literal: true

require "slim"

require_relative "minify/version"

require_relative "minify/tag"
require_relative "minify/javascript"

module Slim
  class Embedded < Filter
    class TagEngine < Engine
      prepend Minify::Tag
    end

    class JavaScriptEngine < TagEngine
      prepend Minify::Javascript
    end
  end
end
