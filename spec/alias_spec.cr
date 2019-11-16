require "./spec_helper"

describe "Alias" do
  it "contains booleans, numbers, and strings" do
    ::Terminfo::Alias::Booleans.class.should   eq Hash(String, Tuple(String, String))
    ::Terminfo::Alias::Numbers.class.should eq Hash(String, Tuple(String, String))
    ::Terminfo::Alias::Strings.class.should eq Hash(String, Tuple(String, String))
  end

  it "has values in booleans, numbers, and strings" do
    ::Terminfo::Alias::Booleans["move_standout_mode"].should eq Tuple.new("msgr",  "ms")
    ::Terminfo::Alias::Numbers["lines_of_memory"].should  eq Tuple.new("lm",    "lm")
    ::Terminfo::Alias::Strings["set_a_background"].should eq Tuple.new("setab",  "AB")
  end
end

