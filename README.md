[![Build Status](https://travis-ci.com/crystallabs/terminfo.svg?branch=master)](https://travis-ci.com/crystallabs/terminfo)
[![Version](https://img.shields.io/github/tag/crystallabs/terminfo.svg?maxAge=360)](https://github.com/crystallabs/terminfo/releases/latest)
[![License](https://img.shields.io/github/license/crystallabs/terminfo.svg)](https://github.com/crystallabs/terminfo/blob/master/LICENSE)

# Terminfo

Terminfo is a terminfo parsing library for Crystal.

It supports:

1. Auto-detecting and searching for terminfo files
1. Parsing terminfo files using regular and extended format
1. Summarizing the content of terminfo files
1. Providing raw access to parsed terminfo data
1. Using internally stored terminfo data for most common terminals

It is implemented natively and does not depend on ncurses or other external library.

## Installation

Add the dependency to `shard.yml`:

```yaml
dependencies:
  terminfo:
    github: crystallabs/terminfo
    version: 0.4.0
```

## Usage in a nutshell

Here is a basic example that parses a terminfo file, prints parsed headers, and accesses raw data.

```crystal
require "../src/terminfo"

# With own class
class MyClass
  include Terminfo
end
my = MyClass.new auto: true

# With built-in class
my = Terminfo::Data.new path: "/lib/terminfo/x/xterm"

# Using internal 'xterm' definition
my2 = Terminfo::Data.new builtin: "xterm"

p my.header
p my2.extended_header

# Print out a couple raw values
p "Boolean auto_left_margin = %s" % my.booleans["auto_left_margin"] # => false
p "Number columns = %s" % my.numbers["columns"]                     # => 80
p "String back_tab = %s" % my.strings["back_tab"]                   # => \e[Z
```

## Terminfo files

Terminfo can read files from disk as well as from internal (compiled-in) storage.

For filesystem access, specify terminfo files as absolute or relative paths and they will be read from the specified location.

```
data = Terminfo::Data.new path: "/path/to/t/te/terminfo_file"
```

For a lookup in standard terminfo files or directories, specify terminal name:

```
data = Terminfo::Data.new term: "xterm"
```

The file and directory search order is from first to last:

```
ENV["TERMINFO_DIRS"]/     # (List of directory paths split by ":")
ENV["HOME"]/.terminfo/
/usr/share/terminfo/
/usr/share/lib/terminfo/
/usr/lib/terminfo/
/usr/local/share/terminfo/
/usr/local/share/lib/terminfo/
/usr/local/lib/terminfo/
/usr/local/ncurses/lib/terminfo/
/lib/terminfo/**
```

A file is searched in each directory using two attempts:

```
./file
./f/fi/file
```

For a lookup in this module's built-in storage, specify built-in name:

```
data = Terminfo::Data.new builtin: "xterm"
```

Built-in terminfo definitions can be changed by modifying the contents of the
directory `filesystem/`. Currently available terminfo files are:

```
linux
windows-ansi
xterm
xterm-256color
```

For autodetection, request it with:

```
data = Terminfo::Data.new auto: true
```

If file `ENV["TERMINFO"]` exists, it will be used instead of performing
autodetection.

Otherwise, autodetection will be performed and the terminfo file will be
searched in the above documented directories.

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
