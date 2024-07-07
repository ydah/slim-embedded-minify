# SlimEmbeddedMinify

[![Gem Version](https://badge.fury.io/rb/slim-embedded-minify.svg)](https://badge.fury.io/rb/slim-embedded-minify)
[![test](https://github.com/ydah/slim-embedded-minify/actions/workflows/minitest.yml/badge.svg)](https://github.com/ydah/slim-embedded-minify/actions/workflows/minitest.yml)
[![RubyDoc](https://img.shields.io/badge/%F0%9F%93%9ARubyDoc-documentation-informational.svg)](https://www.rubydoc.info/gems/slim-embedded-minify)

A slim file to minify embedded code.

## Overview

Remove comments and unnecessary blank lines in the [css or javascript embedding](https://github.com/slim-template/slim#embedded-engines-markdown-) of your Slim files when embedding them in HTML.

### Example

You have a Slim file like this:

```slim
html
  head
    title My Slim Template
  body
    h1 Welcome to Slim!
    css:
      /* Slim supports embedded css */


      body { background-color: #ddd; }
    javascript:
      // Slim supports embedded javascript
      alert('Slim supports embedded javascript!')
```

If this gem is not applied, the HTML will look like the following:

```html
<html>
  <head>
    <title>My Slim Template</title>
  </head>
  <body>
    <h1>
      Welcome to Slim!
    </h1>
    <style>
      /* Slim supports embedded css */


      body { background-color: #ddd; }
    </style>
    <script>
      // Slim supports embedded javascript
      alert('Slim supports embedded javascript!')
    </script>
  </body>
</html>
```

Applying this gem will remove unnecessary blank lines and comments:

```html
<html>
  <head>
    <title>My Slim Template</title>
  </head>
  <body>
    <h1>
      Welcome to Slim!
    </h1>
    <style>
      body { background-color: #ddd; }
    </style>
    <script>
      alert('Slim supports embedded javascript!')
    </script>
  </body>
</html>
```

## Installation

Add this line to your application's Gemfile:

```ruby
# Gemfile
gem 'slim'
gem 'slim-embedded-minify'
```

And then execute:

```
bundle install
```

## Usage

All you have to do is add this gem to your Gemfile.
No additional configuration or changes to your code are required.

```ruby
# Gemfile
gem 'slim'
gem 'slim-embedded-minify'
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/ydah/slim-embedded-minify. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/ydah/slim-embedded-minify/blob/main/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Slim::Embedded::Minify project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/ydah/slim-embedded-minify/blob/main/CODE_OF_CONDUCT.md).
