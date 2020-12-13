require "../src/terminfo"

my = Terminfo.new path: "/lib/terminfo/x/xterm"

p my.header
p my.extended_header

## Print out a couple raw values. Use p() which inspects variables.
## Using puts() would output any escape sequences to the terminal.
#p my.capabilities.booleans["auto_left_margin"] # => false
#p my.capabilities.numbers["columns"]           # => 80
#p my.capabilities.strings["back_tab"]          # => \e[Z
