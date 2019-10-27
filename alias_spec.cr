require "./spec_helper"

describe "Alias" do
  it "contains bools, numbers, and strings" do
    ::Crysterm::Alias::BOOLS.class.should   eq Hash(String, Tuple(String, String))
    ::Crysterm::Alias::NUMBERS.class.should eq Hash(String, Tuple(String, String))
    ::Crysterm::Alias::STRINGS.class.should eq Hash(String, Tuple(String, String))
  end

  it "has values in bools, numbers, and strings" do
    ::Crysterm::Alias::BOOLS["move_standout_mode"].should eq Tuple.new("msgr",  "ms")
    ::Crysterm::Alias::NUMBERS["lines_of_memory"].should  eq Tuple.new("lm",    "lm")
    ::Crysterm::Alias::STRINGS["set_a_background"].should eq Tuple.new("setab",  "AB")
  end
end

