require "../src/crysterm"
require "../src/tput"
require "../src/helpers"

class T < ::Crysterm::Tput
end

t = T.new
t.read_terminfo("./usr/xterm")

#p t.terminal

