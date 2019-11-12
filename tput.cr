require "../src/crysterm"
require "../src/tput"
require "../src/helpers"

class T < ::Crysterm::Tput
end

t = T.new(terminfo_file: "./usr/xterm")
#t.read_terminfo
#t.compile_terminfo

#p t.terminal

