require "./spec_helper"

describe Terminfo do
  # Load terminfo file
  data = Terminfo::Data.new path: "./filesystem/xterm"
  data.name.should eq "xterm"

  # Load terminfo from system
  data = Terminfo::Data.new term: "xterm-256color"
  data.name.should eq "xterm-256color"

  # Load terminfo from built-in
  data = Terminfo::Data.new builtin: "windows-ansi"
  data.name.should eq "ansi"

  # Load terminfo via autodetect
  expected_term = ENV["TERM"] || "xterm"
  data = Terminfo::Data.new
  data.name.should eq expected_term
end
