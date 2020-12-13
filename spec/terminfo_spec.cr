require "./spec_helper"

describe Terminfo do
  it "contains booleans, numbers, and strings" do
    ::Terminfo::Capabilities::Booleans::Table.class.should eq Array(Array(String))
    ::Terminfo::Capabilities::Numbers::Table.class.should eq Array(Array(String))
    ::Terminfo::Capabilities::Strings::Table.class.should eq Array(Array(String))
  end

  it "has values in booleans, numbers, and strings" do
    ::Terminfo::Capabilities::Booleans::Table[0][1].should eq "auto_left_margin"
    ::Terminfo::Capabilities::Booleans["auto_left_margin"].should eq 0

    ::Terminfo::Capabilities::Numbers["label_width"].should eq 10
    ::Terminfo::Capabilities::Numbers["lw"].should eq 10
    ::Terminfo::Capabilities::Numbers["LabelWidth"].should eq 10

    ::Terminfo::Capabilities::Strings["box_chars_1"].should eq ::Terminfo::Capabilities::Strings::Table.size-1
  end

  it "has internal storage" do
    ::Terminfo::Storage.has_internal?("xterm").should be_true
    ::Terminfo::Storage.has_internal?("nonexistent").should be_false

    ::Terminfo::Storage.get_internal?("xterm").class.should eq ::BakedFileSystem::BakedFile
    ::Terminfo::Storage.get_internal("xterm").read.size.should eq 3328
  end

  it "can parse terminfo file content" do
    tidata = ::Terminfo::Term.new ::IO::Memory.new(::Terminfo::Storage.get_internal("xterm").read), true
    tidata.header.to_h.should eq({
      :data_size => 3337,
      :header_size => 12,
      :magic_number => 282,
      :names_size => 28,
      :booleans_size => 38,
      :numbers_size => 15,
      :strings_size => 413,
      :strings_table_size => 1388,
      :total_size => 2322,
    })

    tidata.extended_header.not_nil!.to_h.should eq({
      :header_size => 10,
      :booleans_size => 2,
      :numbers_size => 0,
      :strings_size => 62,
      :strings_table_size => 126,
      :last_strings_table_offset => 751,
      :symbol_offsets_size => 64,
      :total_size => 262,
    })

    tidata.booleans.size.should eq tidata.header.booleans_size

    # Now asking for == numbers_size because -1 values aren't stored.
    tidata.numbers.size.should eq 5 #tidata.header.numbers_size
    tidata.strings.size.should eq 169 #tidata.header.strings_size

    tidata.extended_booleans.size.should eq tidata.extended_header.not_nil!.booleans_size
    tidata.extended_numbers.size.should eq tidata.extended_header.not_nil!.numbers_size
    tidata.extended_strings.size.should eq tidata.extended_header.not_nil!.strings_size
  end
end
