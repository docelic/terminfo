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
end

