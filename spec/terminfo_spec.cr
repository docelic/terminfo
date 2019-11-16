require "./spec_helper"

describe Terminfo do
  it "contains booleans, numbers, and strings" do
    ::Terminfo::Booleans.class.should   eq Array(String)
    ::Terminfo::Numbers.class.should eq Array(String)
    ::Terminfo::Strings.class.should eq Array(String)
  end

  it "has values in booleans, numbers, and strings" do
    ::Terminfo::Booleans[0].should eq "auto_left_margin"
    ::Terminfo::Numbers[10].should  eq "label_width"
    ::Terminfo::Strings[-1].should eq "box_chars_1"
  end

  it "has internal storage" do
    ::Terminfo.has_internal?("xterm").should be_true
    ::Terminfo.has_internal?("nonexistent").should be_false

    ::Terminfo.get_internal?("xterm").class.should eq ::BakedFileSystem::BakedFile
    ::Terminfo.get_internal("xterm").read.size.should eq 3328
  end
end
