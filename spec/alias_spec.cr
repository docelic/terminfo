require "./spec_helper"

describe "Alias" do
  it "contains booleans, numbers, and strings" do
    ::Terminfo::Alias::Booleans.class.should   eq Hash(String, Array(String))
    ::Terminfo::Alias::Numbers.class.should eq Hash(String, Array(String))
    ::Terminfo::Alias::Strings.class.should eq Hash(String, Array(String))
  end

  it "has values in booleans, numbers, and strings" do
    ::Terminfo::Alias::Booleans["move_standout_mode"].should eq ["msgr",  "ms"]
    ::Terminfo::Alias::Numbers["lines_of_memory"].should  eq ["lm",    "lm"]
    ::Terminfo::Alias::Strings["set_a_background"].should eq ["setab",  "AB"]
  end
end

