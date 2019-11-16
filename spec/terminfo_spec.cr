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

  it "can parse terminfo file content" do
    tidata = ::Terminfo::Data.new ::Terminfo.get_internal("xterm")
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
      :sym_offset_size => 64,
      :total_size => 262,
    })

    tidata.booleans.size.should eq tidata.header.booleans_size
    tidata.numbers.size.should eq tidata.header.numbers_size
    tidata.strings.size.should eq tidata.header.strings_size

    tidata.extended_booleans.size.should eq tidata.extended_header.not_nil!.booleans_size
    tidata.extended_numbers.size.should eq tidata.extended_header.not_nil!.numbers_size
    tidata.extended_strings.size.should eq tidata.extended_header.not_nil!.strings_size
  end
end
