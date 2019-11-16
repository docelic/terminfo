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
    version: 0.6.0
```

## Usage in a nutshell

Here is a basic example that parses a terminfo file, prints parsed headers, and accesses raw data.

```crystal
require "../src/terminfo"

# With own class
class MyClass
  include Terminfo
end
my = MyClass.new autodetect: true

# With built-in class
my = Terminfo::Data.new path: "/lib/terminfo/x/xterm"

# Using internal 'xterm' definition
my2 = Terminfo::Data.new builtin: "xterm"

p my.header
p my2.extended_header

# Print out a couple raw values. Use p() which inspects variables.
# Using puts() would output any escape sequences to the terminal.
p my.booleans["auto_left_margin"] # => false
p my.numbers["columns"]           # => 80
p my.strings["back_tab"]          # => \e[Z
```

## Terminfo initialization

Terminfo can read terminfo data from files on disk as well as from internal (compiled-in) storage.

For specific terminfo files, specify absolute or relative path:

```crystal
data = Terminfo::Data.new path: "/path/to/t/te/terminfo_file"
```

For lookup in default terminfo directories, specify term name:

```crystal
data = Terminfo::Data.new term: "xterm"
```

The default directory search order from first to last:

```crystal
ENV["TERMINFO_DIRS"]/     # (List of directories split by ":")
ENV["HOME"]/.terminfo/
/usr/share/terminfo/
/usr/share/lib/terminfo/
/usr/lib/terminfo/
/usr/local/share/terminfo/
/usr/local/share/lib/terminfo/
/usr/local/lib/terminfo/
/usr/local/ncurses/lib/terminfo/
/lib/terminfo/
```

Directory search order can be changed by modifying `Terminfo.directories`.

A file is searched in each directory using the following attempts:

```crystal
./file
./f/file
./f/fi/file
```

For lookup in the module's built-in storage, specify built-in name:

```crystal
data = Terminfo::Data.new builtin: "xterm"
```

Built-in terminfo definitions can be changed by modifying the contents of the
directory `filesystem/`. Currently available built-in terminfo files are:

```crystal
linux
windows-ansi
xterm
xterm-256color
```

For autodetection, request it or call `initialize` with no arguments:

```crystal
data = Terminfo::Data.new autodetect: true

data = Terminfo::Data.new
```

If environment variable `ENV["TERMINFO"]` is set, term definition will
be read from the specified file.

Otherwise, term name will be read from `ENV["TERM"]` and the corresponding
terminfo file will be searched in the above documented directories.

If `TERMINFO` and `TERM` are unset, a built-in default of "xterm" will be used.

## Terminfo data

Once you have instantiated Terminfo via your own class or built-in `Terminfo::Data`,
the following parsed properties and data structure will be available:

```crystal
data = Terminfo::Data.new term: "xterm"

# pp data

#<Terminfo::Data
 @name="xterm",
 @names=["xterm-debian"],
 @description="X11 terminal emulator",

 @header=
  #<Terminfo::Header
   @booleans_size=38,
   @data_size=3360,
   @header_size=12,
   @magic_number=282,
   @names_size=41,
   @numbers_size=15,
   @strings_size=413,
   @strings_table_size=1397,
   @total_size=2344>,

 @extended_header=
  #<Terminfo::ExtendedHeader
   @booleans_size=2,
   @header_size=10,
   @last_strings_table_offset=750,
   @numbers_size=0,
   @strings_size=62,
   @strings_table_size=126,
   @symbol_offsets_size=64,
   @total_size=262>,

 @booleans=
  {"auto_left_margin" => false,
  # ...
  "backspaces_with_bs" => true},
 @numbers=
  {"columns" => 80,
  # ...
  "max_pairs" => 64},
 @strings=
  {"back_tab" => "\e[Z",
  # ...
  "memory_unlock" => "\em"}>

 @extended_booleans=
  {"AX" => true,
  # ...
  "XT" => true},
 @extended_numbers=
  {"some_name" => 0,
  # ...
  },
 @extended_strings=
  {"Cr" => "\e]112\a",
  # ...
  "kc2" => ""}
>
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

- https://github.com/crystallabs/crysterm - Console/term toolkit for Crystal
