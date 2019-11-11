require "../src/crysterm"
require "../src/tput"
require "../src/helpers"
require "../src/crysterm_post"

class T < ::Crysterm::Tput
end

t = T.new(terminfo_file: "./usr/xterm")
#t.read_terminfo
#t.compile_terminfo

#p t.terminal

