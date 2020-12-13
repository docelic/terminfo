require "../src/terminfo"

t = Terminfo.new path: "/lib/terminfo/x/xterm"
t = Terminfo.new term: "xterm"
t = Terminfo.new builtin: "xterm"
t = Terminfo.new
