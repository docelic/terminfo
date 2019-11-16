require "./spec_helper"

describe Terminfo do
  it "contains bools, numbers, and strings" do
    ::Terminfo::Bools.class.should   eq Array(String)
    ::Terminfo::Numbers.class.should eq Array(String)
    ::Terminfo::Strings.class.should eq Array(String)
  end

  it "has values in bools, numbers, and strings" do
    ::Terminfo::Bools[0].should eq "auto_left_margin"
    ::Terminfo::Numbers[10].should  eq "label_width"
    ::Terminfo::Strings[-1].should eq "box_chars_1"
  end
end
