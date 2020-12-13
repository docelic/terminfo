class Terminfo

  module TermImpl
    macro read_i16le(io)
      io.read_bytes(Int16, IO::ByteFormat::LittleEndian)
    end
    macro read_i8le(io)
      io.read_bytes(Int8, IO::ByteFormat::LittleEndian)
    end

    Booleans = Capabilities::Booleans::List
    Numbers  = Capabilities::Numbers::List
    Strings  = Capabilities::Strings::List

    # Contents of terminfo file header
    property header : Header
    # Name of parsed terminfo term
    property name : String
    # Any alias names of parsed terminfo term. This list does not include
    # the main name which is available in `#name`.
    property names : Array(String)
    # Description from the parsed terminfo
    property description : String
    # List of boolean capabilities
    property booleans : Hash(String,Bool?)
    # List of numeric capabilities
    property numbers : Hash(String,Int16?)
    # List of string capabilities
    property strings : Hash(String,String?)

    # Contents of extended terminfo file header
    property extended_header : ExtendedHeader?
    # List of boolean capabilities from extended data
    property extended_booleans : Hash(String,Bool?)
    # List of numeric capabilities from extended data
    property extended_numbers : Hash(String,Int16?)
    # List of string capabilities from extended data
    property extended_strings : Hash(String,String?)

    def initialize(io : IO, extended : Bool)
      # The format has been chosen so that it will be the same on all hardware.
      # An 8 or more bit byte is assumed, but no assumptions about byte
      # ordering or sign extension are made. The compiled file is created with
      # the tic program, and read by the routine setupterm. The file is divided
      # into six parts: the header, terminal names, boolean flags, numbers,
      # strings, and string table.

      # The header section begins the file. This section contains six short
      # integers in the format described below. These integers are:
      # (1) the magic number (octal 0432);
      # (2) the size, in bytes, of the names section;
      # (3) the number of bytes in the boolean section;
      # (4) the number of short integers in the numbers section;
      # (5) the number of offsets (short integers) in the strings section;
      # (6) the size, in bytes, of the string table.

      # For some xterm, non-extended header:
      # { data_size: 3270,
      #   headerSize: 12,
      #   magic_number: 282,
      #   names_size: 48,
      #   booleans_size: 38,
      #   numbers_size: 15,
      #   strings_size: 413,
      #   strings_table_size: 1388,
      #   total: 2342 }

      # For some xterm, layout:
      # { header: '0 - 10', // length: 10
      #   booleans: '10 - 12', // length: 2
      #   numbers: '12 - 14', // length: 2
      #   strings: '14 - 128', // length: 114 (57 short)
      #   symoffsets: '128 - 248', // length: 120 (60 short)
      #   stringtable: '248 - 612', // length: 364
      #   sym: '612 - 928' } // length: 316
      #
      # How lastStrTableOffset works:
      #   data.length - h.lastStrTableOffset === 248
      #     (sym-offset end, string-table start)
      #   364 + 316 === 680 (lastStrTableOffset)
      # How strings_table_size works:
      #   h.strings_size + [symOffsetCount] === h.strings_table_size
      #   57 + 60 === 117 (strings_table_size)
      #   symOffsetCount doesn't actually exist in the header. it's just implied.
      # Getting the number of sym offsets:
      #   h.symOffsetCount = h.strings_table_size - h.strings_size;
      #   h.symOffsetSize = (h.strings_table_size - h.strings_size) * 2;

      @header = Header.new io

      names_string = io.read_string header.names_size
      # Names is nul-terminated, check for it.
      raise "Names must be nul-terminated" unless names_string[-1].ord==0

      names= names_string[..-2].split '|'
      @name = (names.shift || "").downcase
      @description = names.pop || ""
      @names = names

      # Booleans Section; One byte for each flag
      # Same order as <term.h>
      @booleans = Hash(String,Bool?).new
      @header.booleans_size.times do |i|
        @booleans[Booleans[i]] = read_i8le(io) == 1
      end

      if (io.pos % 2)>0
        # Null byte in between to make sure numbers begin on an even byte.
        io.seek 1, ::IO::Seek::Current
      end

      # Numbers Section
      @numbers = Hash(String,Int16?).new
      @header.numbers_size.times do |i|
        n = ::Terminfo::TermImpl.read_i16le(io)
        n = -1i16 if n == 65535
        #puts "#{v} = #{n}"
        if n != -1
          @numbers[Numbers[i]] = n
        end
      end

      if (io.pos % 2)>0
        # Null byte in between to make sure numbers begin on an even byte.
        io.seek 1, ::IO::Seek::Current
      end

      # Strings section. This section contains offsets, which then need to be read.
      endpos = io.pos + header.strings_size * 2
      @strings = Hash(String,String?).new
      @header.strings_size.times do |i|
        k = Strings[i]
        offset = ::Terminfo::TermImpl.read_i16le(io)
        pos = io.pos
        # Workaround: fix an odd bug in the screen-256color terminfo where it tries
        # to set -1, but it appears to have {0xfe, 0xff} (65534) instead of {0xff, 0xff} (65535).
        if offset==65534
          offset=-1
        elsif offset<-1
          raise Exception.new "Invalid string offset: #{offset}"
        end

        if offset != -1
          io.seek endpos+offset, ::IO::Seek::Set
          c = io.gets(Char::ZERO, true) #|| ""
          @strings[k] = c if c
        end
        io.seek pos, ::IO::Seek::Set
      end
      #pos = endpos
      #io.seek endpos, ::IO::Seek::Set

      # We've parsed the string offsets, now advance forward by the size of the strings table
      io.seek endpos + header.strings_table_size, ::IO::Seek::Set

      if !extended || (io.pos == header.data_size)
        #[
        #  header,
        #  name,
        #  parts, # names
        #  desc,
        #  file,
        #  booleans,
        #  numbers,
        #  strings
        #]
        return
      else
        if (io.pos % 2)>0
          # Null byte in between to make sure numbers begin on an even byte.
          io.seek 1, ::IO::Seek::Current
        end

        @extended_header,
        @extended_booleans,
        @extended_numbers,
        @extended_strings = parse_extended(io)
      end
    end

    # :nodoc:
    def parse_extended(io)

      # The ncurses libraries and applications support extended terminfo
      # binary format, allowing users to define capabilities which are
      # loaded at runtime. This extension is made possible by using the
      # fact that the other implementations stop reading the terminfo data
      # when they have reached the end of the size given in the header.
      # ncurses checks the size, and if it exceeds that due to the
      # predefined data, continues to parse according to its own scheme.

      # For xterm, extended header:
      # Offset: 2342
      # { header:
      #    { data_size: 928,
      #      headerSize: 10,
      #      booleans_size: 2,
      #      numbers_size: 1,
      #      strings_size: 57,
      #      strings_table_size: 117,
      #      lastStrTableOffset: 680,
      #      total: 245 },

      header = ExtendedHeader.new io

      # Booleans Section
      # One byte for each flag
      # Same order as <term.h>
      _booleans = [] of Bool?
      header.booleans_size.times do |i|
        _booleans.push read_i8le(io) == 1
      end

      if (io.pos % 2)>0
        io.seek 1, ::IO::Seek::Current
      end

      # Numbers Section
      _numbers = [] of Int16?
      header.numbers_size.times do |i|
        n = ::Terminfo::TermImpl.read_i16le(io)
        n=-1i16 if n == 65535
        _numbers.push (n!=-1) ? n : nil
        #puts "#{v} = #{n}"
      end

      # Strings section
      # TODO combine these 2 blocks into one
      endpos = io.pos + header.symbol_offsets_size * 2 + header.strings_size * 2
      _strings = [] of Int16?
      header.strings_size.times do |i|
        offset = ::Terminfo::TermImpl.read_i16le(io)
        # Workaround: fix an odd bug in the screen-256color terminfo where it tries
        # to set -1, but it appears to have {0xfe, 0xff} (65534) instead of {0xff, 0xff} (65535).
        if offset==65534
          offset=-1i16
        elsif offset<-1
          raise Exception.new "Invalid string offset in extended part: #{offset}"
        end

        _strings.push (offset!=-1) ? offset : nil
      end
      # Both are alternative ways and work:
      #p io.size - header.lastStrTableOffset
      #p io.pos + header.symOffsetCount*2
      io.seek (io.pos + header.symbol_offsets_size*2), ::IO::Seek::Set
      # Remember the pos we are at after having parsed the offsets table
      pos = io.pos
      high = 0 # Index at which string table is done
      _strings2 = [] of String?
      _strings.each do |offset|
        unless offset
           # XXX or just next?
          _strings2.push nil
        else
          io.seek pos+offset, ::IO::Seek::Set
          _strings2.push io.gets(Char::ZERO,true) #|| ""
          high = io.pos if io.pos > high
        end
      end

      io.seek high, ::IO::Seek::Set

      # XXX not sure if needed?
      if (io.pos % 2)>0
        io.seek 1, ::IO::Seek::Current
      end

      # Symbol Table

      symbols = [] of String
      while s = io.gets(Char::ZERO,true)
        symbols.push s
      end

      #Log.debug symbols, :extended_symbols

      # Identify by name
      j = 0

      booleans = {} of String => Bool?
      _booleans.each do |bool|
        booleans[symbols[j]] = bool
        j+=1
      end

      numbers = {} of String => Int16?
      _numbers.each do |number|
        numbers[symbols[j]] = number
        j+=1
      end

      strings = {} of String => String?
      _strings2.each do |string|
        strings[symbols[j]] = string
        j+=1
      end

      raise Exception.new("Not at end of file? Currently at #{io.pos}, should be at #{io.size}?") unless io.pos == io.size
      { header, booleans, numbers, strings }
    end

    # Conventional (non-extended) terminfo header data
    class Header
      property data_size : Int16
      property header_size : Int16
      property magic_number : Int16
      property names_size : Int16
      property booleans_size : Int16
      property numbers_size : Int16
      property strings_size : Int16
      property strings_table_size : Int16
      property total_size : Int16

      def initialize(io : IO)
        @data_size      = io.size.to_i16
        @header_size    = 12
        @magic_number   = ::Terminfo::TermImpl.read_i16le(io) #(io[1] << 8) | io[0]

        #if @magic_number != 282
        #  raise Exception.new "Bad magic number; expecting: 0x11A, got: #{@magic_number}"
        #end

        @names_size     = ::Terminfo::TermImpl.read_i16le(io) #(io[3] << 8) | io[2]
        @booleans_size     = ::Terminfo::TermImpl.read_i16le(io) #(io[5] << 8) | io[4]
        @numbers_size   = ::Terminfo::TermImpl.read_i16le(io) #(io[7] << 8) | io[6]
        @strings_size   = ::Terminfo::TermImpl.read_i16le(io) #(io[9] << 8) | io[8]
        @strings_table_size = ::Terminfo::TermImpl.read_i16le(io) #(io[11] << 8) | io[10]
        @total_size     = @header_size + @names_size + @booleans_size + @numbers_size*2 + @strings_size*2 + @strings_table_size

        raise Exception.new "Invalid header section: names" if @names_size <= 0
        raise Exception.new "Invalid header section: booleans" if @booleans_size < 0
        raise Exception.new "Invalid header section: numbers" if @numbers_size < 0
        raise Exception.new "Invalid header section: strings" if @strings_size < 0
        raise Exception.new "Invalid header section size: strings" if @strings_table_size < 0

        raise Exception.new "Too many booleans" if @booleans_size > Booleans.size
        raise Exception.new "Too many numbers" if @numbers_size > Numbers.size
        raise Exception.new "Too many strings" if @strings_size > Strings.size
      end

      # Converts Terminfo header object to Hash
      def to_h
        {
          :data_size          => @data_size,
          :header_size        => @header_size,
          :magic_number       => @magic_number,
          :names_size         => @names_size,
          :booleans_size      => @booleans_size,
          :numbers_size       => @numbers_size,
          :strings_size       => @strings_size,
          :strings_table_size => @strings_table_size,
          :total_size         => @total_size,
        }
      end
    end

    # Extended terminfo header data
    class ExtendedHeader
      property header_size : Int16
      property booleans_size : Int16
      property numbers_size : Int16
      property strings_size : Int16
      property strings_table_size : Int16
      property last_strings_table_offset : Int16
      property total_size : Int16
      property symbol_offsets_size : Int16

      def initialize(io : IO)
        @header_size           = 10
        @booleans_size         = ::Terminfo::TermImpl.read_i16le(io)
        @numbers_size          = ::Terminfo::TermImpl.read_i16le(io)
        @strings_size          = ::Terminfo::TermImpl.read_i16le(io)
        @strings_table_size    = ::Terminfo::TermImpl.read_i16le(io)
        @last_strings_table_offset = ::Terminfo::TermImpl.read_i16le(io)
        @symbol_offsets_size   = @strings_table_size - @strings_size
        @total_size            = @header_size + @booleans_size + @numbers_size*2 + @strings_size*2 + @strings_table_size
      end

      # Converts extended Terminfo header object to Hash
      def to_h
        {
          :header_size         => @header_size,
          :booleans_size       => @booleans_size,
          :numbers_size        => @numbers_size,
          :strings_size        => @strings_size,
          :strings_table_size  => @strings_table_size,
          :last_strings_table_offset => @last_strings_table_offset,
          :symbol_offsets_size => @symbol_offsets_size,
          :total_size          => @total_size,
        }
      end
    end
  end

  class Term
    include TermImpl
  end
end
