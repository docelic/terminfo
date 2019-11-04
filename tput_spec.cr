require "./spec_helper"

describe "Tput" do
  it "contains bools, numbers, and strings" do
    ::Crysterm::Tput::Bools.class.should   eq Array(String)
    ::Crysterm::Tput::Numbers.class.should eq Array(String)
    ::Crysterm::Tput::Strings.class.should eq Array(String)
  end

  it "has values in bools, numbers, and strings" do
    ::Crysterm::Tput::Bools[0].should eq "auto_left_margin"
    ::Crysterm::Tput::Numbers[10].should  eq "label_width"
    ::Crysterm::Tput::Strings[-1].should eq "box_chars_1"
  end

  it "has acsc and utoa" do
    ::Crysterm::Tput::Acsc["c"].should eq "\u000c"
    ::Crysterm::Tput::Utoa["\u2524"].should eq "+"
  end

  it "has fallback termcap" do
    ::Crysterm::Tput::Termcap.should be_a String
  end

  # XXX does tput need to be a class? Can it be a module?
  it "can instantiate" do
    obj = ::Crysterm::Tput.new
    obj.should be_truthy
  end

  it "can report term" do
    obj = ::Crysterm::Tput.new(terminal="xterm-256color")
    obj.term("xterm").should be_true
    obj.term("abcdef").should be_false
  end

  # TODO enable this test when term files are loaded via
  # baked filesystem
  #it "can detect features" do
  #  obj = ::Crysterm::Tput.new(terminal="xterm")

  #  obj.detect_magic_cookie.should be_true
  #  obj.detect_padding.should be_true
  #  obj.detect_setbuf.should be_true

  #  ENV["NCURSES_NO_MAGIC_COOKIE"]="1"
  #  ENV["NCURSES_NO_PADDING"]="1"
  #  ENV["NCURSES_NO_SETBUF"]="1"

  #  obj.detect_magic_cookie.should be_false
  #  obj.detect_padding.should be_false
  #  obj.detect_setbuf.should be_false

  #  ENV.delete "NCURSES_NO_MAGIC_COOKIE"
  #  ENV.delete "NCURSES_NO_PADDING"
  #  ENV.delete "NCURSES_NO_SETBUF"

  #  info = obj.read_terminfo("/terminfo/xterm")
  #  obj.detect_pcrom_set(info).should be_false

  #  # TODO detect_unicode not tested currently
  #end

  # TODO enable when possible
  # parse_terminfo tests:

  # For ../filesystem/terminfo/xterm, non-extended header:
  # { dataSize: 3270,
  #   headerSize: 12,
  #   magicNumber: 282,
  #   namesSize: 28,
  #   boolCount: 38,
  #   numCount: 15,
  #   strCount: 413,
  #   strTableSize: 1388,
  #   total: 2322 }

  # For xterm, extended header:
  # Offset: 2342
  # { header:
  #    { dataSize: 928,
  #      headerSize: 10,
  #      boolCount: 2,
  #      numCount: 1,
  #      strCount: 57,
  #      strTableSize: 117,
  #      lastStrTableOffset: 680,
  #      total: 245 },
  # For ./filesystem/terminfo/xterm:
  #  {"dataSize" => 3337, "headerSize" => 10, "boolCount" => 2, "numCount" => 0, "strCount" => 62, "strTableSize" => 126, "lastStrTableOffset" => 751, "total" => 262}

end

