require "./spec_helper"

describe Terminfo do
  data = Terminfo::Data.new path: "/lib/terminfo/x/xterm" # Not accurate on macOS, fails
  data.name.should eq "xterm"

  data = Terminfo::Data.new term: "xterm-256color"
  data.name.should eq "xterm-256color"

  data = Terminfo::Data.new builtin: "windows-ansi"
  data.name.should eq "ansi"

  data = Terminfo::Data.new
  data.name.should eq "xterm"
end
