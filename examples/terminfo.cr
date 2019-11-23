require "../src/terminfo"

# With own class
class MyClass
  include Terminfo
end
my = MyClass.new

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
