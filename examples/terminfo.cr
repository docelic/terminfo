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

# Print out a couple raw values
p "Boolean auto_left_margin = %s" % my.booleans["auto_left_margin"]
p "Number columns = %s" % my.numbers["columns"]
p "String back_tab = %s" % my.strings["back_tab"]
