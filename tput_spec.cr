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
    obj = ::Crysterm::Tput.new(terminal="abcdef-256color")
    obj.term("xterm").should be_false
    obj.term("abcdef").should be_true
    obj.term("abcdef").should be_true
  end

  it "can detect features" do
    obj = ::Crysterm::Tput.new

    obj.detect_magic_cookie.should be_true
    obj.detect_padding.should be_true
    obj.detect_setbuf.should be_true

    ENV["NCURSES_NO_MAGIC_COOKIE"]="1"
    ENV["NCURSES_NO_PADDING"]="1"
    ENV["NCURSES_NO_SETBUF"]="1"

    obj.detect_magic_cookie.should be_false
    obj.detect_padding.should be_false
    obj.detect_setbuf.should be_false

    ENV.delete "NCURSES_NO_MAGIC_COOKIE"
    ENV.delete "NCURSES_NO_PADDING"
    ENV.delete "NCURSES_NO_SETBUF"

    # TODO detect_unicode not tested currently

  end
end

