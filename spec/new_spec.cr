require "./spec_helper"

describe Terminfo do
  # Load terminfo file
  tinfo = Terminfo.new path: "./filesystem/xterm"
  tinfo.data.name.should eq "xterm"

  # Load terminfo from system
  tinfo = Terminfo.new term: "xterm-256color"
  tinfo.data.name.should eq "xterm-256color"

  # Load terminfo from built-in
  tinfo = Terminfo.new builtin: "windows-ansi"
  tinfo.data.name.should eq "ansi"

  # Load terminfo via autodetect
  expected_term = ENV["TERM"] || "xterm"
  tinfo = Terminfo.new
  tinfo.data.name.should eq expected_term
end
