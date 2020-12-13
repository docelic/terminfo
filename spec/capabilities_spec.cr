require "./spec_helper"

describe "Capabilities" do
  it "contains booleans, numbers, and strings" do
    ::Terminfo::Capabilities::Booleans::Indices.class.should eq Hash(String, Int32)
    ::Terminfo::Capabilities::Numbers::Indices.class.should eq Hash(String, Int32)
    ::Terminfo::Capabilities::Strings::Indices.class.should eq Hash(String, Int32)

    ::Terminfo::Capabilities::Booleans::List.class.should eq Array(String)
    ::Terminfo::Capabilities::Numbers::List.class.should eq Array(String)
    ::Terminfo::Capabilities::Strings::List.class.should eq Array(String)

    ::Terminfo::Capabilities::Booleans::Table.class.should eq Array(Array(String))
    ::Terminfo::Capabilities::Numbers::Table.class.should eq Array(Array(String))
    ::Terminfo::Capabilities::Strings::Table.class.should eq Array(Array(String))
  end

  it "has values in booleans, numbers, and strings" do
    ::Terminfo::Capabilities::Booleans["move_standout_mode"].should eq 14
    ::Terminfo::Capabilities::Booleans["msgr"].should eq 14
    ::Terminfo::Capabilities::Booleans["ms"].should eq 14
    ::Terminfo::Capabilities::Booleans::List[14].should eq "move_standout_mode"
    ::Terminfo::Capabilities::Booleans::MoveStandoutMode.should eq 14
    ::Terminfo::Capabilities::Booleans.move_standout_mode.should eq 14

    ::Terminfo::Capabilities::Numbers["lines_of_memory"].should eq 3
    ::Terminfo::Capabilities::Numbers["lm"].should eq 3
    ::Terminfo::Capabilities::Numbers::List[3].should eq "lines_of_memory"
    ::Terminfo::Capabilities::Numbers::LinesOfMemory.should eq 3
    ::Terminfo::Capabilities::Numbers.lines_of_memory.should eq 3

    ::Terminfo::Capabilities::Strings["set_a_background"].should eq 360
    ::Terminfo::Capabilities::Strings["setab"].should eq 360
    ::Terminfo::Capabilities::Strings["AB"].should eq 360
    ::Terminfo::Capabilities::Strings::List[360].should eq "set_a_background"
    ::Terminfo::Capabilities::Strings::SetABackground.should eq 360
    ::Terminfo::Capabilities::Strings.set_a_background.should eq 360
  end
end
