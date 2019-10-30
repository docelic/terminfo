require "./spec_helper"

describe "Alias" do
  it "contains bools, numbers, and strings" do
    ::Crysterm::Alias::Bools.class.should   eq Hash(String, Tuple(String, String))
    ::Crysterm::Alias::Numbers.class.should eq Hash(String, Tuple(String, String))
    ::Crysterm::Alias::Strings.class.should eq Hash(String, Tuple(String, String))
  end

  it "has values in bools, numbers, and strings" do
    ::Crysterm::Alias::Bools["move_standout_mode"].should eq Tuple.new("msgr",  "ms")
    ::Crysterm::Alias::Numbers["lines_of_memory"].should  eq Tuple.new("lm",    "lm")
    ::Crysterm::Alias::Strings["set_a_background"].should eq Tuple.new("setab",  "AB")
  end
end

