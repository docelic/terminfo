[![Build Status](https://travis-ci.com/crystallabs/terminfo.svg?branch=master)](https://travis-ci.com/crystallabs/terminfo)
[![Version](https://img.shields.io/github/tag/crystallabs/terminfo.svg?maxAge=360)](https://github.com/crystallabs/terminfo/releases/latest)
[![License](https://img.shields.io/github/license/crystallabs/terminfo.svg)](https://github.com/crystallabs/terminfo/blob/master/LICENSE)

# Terminfo

Terminfo is a terminfo parsing library for Crystal.

It supports:

1. Parsing terminfo files using regular and extended format
1. Summarizing the content of terminfo files
1. Providing raw access to parsed terminfo data
1. Using internally stored terminfo data for most common terminals

## Installation

Add the dependency to `shard.yml`:

```yaml
dependencies:
  terminfo:
    github: crystallabs/terminfo
    version: 0.4.0
```

## Usage in a nutshell

Here is a basic example that parses a terminfo file.

```crystal
require "../src/terminfo"

# With own class
class MyClass
  include ::Terminfo
end
my = MyClass.new "/lib/terminfo/x/xterm"

# With built-in class
my = ::Terminfo::Data.new "/lib/terminfo/x/xterm"

# Using internal 'xterm' definition
my2 = ::Terminfo::Data.new ::Terminfo.get_internal "xterm"

p my.header
p my2.extended_header
```

## API documentation

Run `crystal docs` as usual, then open file `docs/index.html`.

Also, see examples in the directory `examples/`.

## Testing

Run `crystal spec` as usual.

Also, see examples in the directory `examples/`.

## Thanks

* All the fine folks on FreeNode IRC channel #crystal-lang and on Crystal's Gitter channel https://gitter.im/crystal-lang/crystal

## Related projects

List of interesting or similar projects in no particular order:

- https://github.com/crystallabs/crysterm - Crysterm is a console/terminal toolkit for Crystal
