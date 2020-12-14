class Terminfo

  module TermImpl
    #::Log.for 'terminfo'

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
    property booleans : Hash(Int16,Bool?)
    # List of numeric capabilities
    property numbers : Hash(Int16,Int32?)
    # List of string capabilities
    property strings : Hash(Int16,String?)

    # Contents of extended terminfo file header
    property extended_header : ExtendedHeader?
    # List of boolean capabilities from extended data
    property extended_booleans : Hash(Int16,Bool?)
    # List of numeric capabilities from extended data
    property extended_numbers : Hash(Int16,Int32?)
    # List of string capabilities from extended data
    property extended_strings : Hash(Int16,String?)

    def initialize(io : IO, extended : Bool, @capabilities : Capabilities)
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
      #   booleans_count: 38,
      #   numbers_count: 15,
      #   strings_count: 413,
      #   strings_table_byte_size: 1388,
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
      # How strings_table_byte_size works:
      #   h.strings_count + [symOffsetCount] === h.strings_table_byte_size
      #   57 + 60 === 117 (strings_table_byte_size)
      #   symOffsetCount doesn't actually exist in the header. it's just implied.
      # Getting the number of sym offsets:
      #   h.symOffsetCount = h.strings_table_byte_size - h.strings_count;
      #   h.symOffsetSize = (h.strings_table_byte_size - h.strings_count) * 2;

      @header = Header.new io

      names_string = io.read_string header.names_size
      # Names is nul-terminated, check for it.
      raise "Names must be nul-terminated" unless names_string[-1].ord==0

      names= names_string[..-2].split '|'
      @name = (names.shift || "").downcase
      @description = names.pop || ""
      @names = names

      Log.trace { "Parsing data for #{name.i}" }

      # Booleans Section; One byte for each flag
      # Same order as <term.h>
      @booleans = Hash(Int16,Bool?).new
      @header.booleans_count.times do |i|
        @booleans[i.to_i16] = read_i8le(io) == 1
      end

      Log.trace { "Parsed booleans for #{name.i}" }

      if (io.pos % 2)>0
        # Null byte in between to make sure numbers begin on an even byte.
        Log.trace { "Skipping a byte (#{io.peek[0]}) for #{name.i}" }
        io.seek 1, ::IO::Seek::Current
      end

      # Numbers Section
      @numbers = Hash(Int16,Int32?).new
      @header.numbers_count.times do |i|
        if @header.magic_number == 282
          n = ::Terminfo::TermImpl.read_i16le(io).to_i32
          Log.trace { "16-bit number nr. #{i}: #{@capabilities.numbers.list[i]}=#{n.i}" }
          n = -1 if n == 65535
        else # 542
          n = ::Terminfo::TermImpl.read_i32le(io)
          Log.trace { "32-bit number nr. #{i}: #{@capabilities.numbers.list[i]}=#{n.i}" }
          #n = -1 if n == 4294967295 # XXX is this a thing?
        end
        #puts "#{v} = #{n}"
        if n<-2
          raise Exception.new "Invalid number: #{n} (must be -2 <= n < max(int16/int32))"
        end
        if n >= 0
          #Log.trace { "Storing capability #{i}=#{n.i}" }
          @numbers[i.to_i16] = n
        end
      end

      if (io.pos % 2)>0
        # Null byte in between to make sure numbers begin on an even byte.
        Log.trace { "Skipping a byte (#{io.peek[0]}) for #{name.i}" }
        io.seek 1, ::IO::Seek::Current
      end

      # Strings section. This section contains offsets, which then need to be read.
      endpos = io.pos + header.strings_count * 2
      @strings = Hash(Int16,String?).new
      @header.strings_count.times do |i|
        offset = ::Terminfo::TermImpl.read_i16le(io)
        pos = io.pos
        # Workaround: fix an odd bug in the screen-256color terminfo where it tries
        # to set -1, but it appears to have {0xfe, 0xff} (65534) instead of {0xff, 0xff} (65535).
        if offset==65534
          offset=-1
        elsif offset<-2
          raise Exception.new "Invalid string offset: #{offset} (must be -2 <= offset < max(int16))"
        end

        if offset >= 0
          io.seek endpos+offset, ::IO::Seek::Set
          c = io.gets(Char::ZERO, true) #|| ""
          @strings[i.to_i16] = c if c
          Log.trace { "String nr. #{i} (#{@capabilities.strings.list[i].i} = #{c.inspect}) is at offset int: #{offset.i}" }
        end
        io.seek pos, ::IO::Seek::Set
      end
      Log.trace { "After parsing strings, io.pos is at: #{io.pos} (for verification, expected pos is: #{endpos})" }

      #pos = endpos
      #io.seek endpos, ::IO::Seek::Set

      # We've parsed the string offsets, now advance forward by the size of the strings table
      io.seek header.strings_table_byte_size, ::IO::Seek::Current
      Log.trace { "After skipping strings table, io.pos is at: #{io.pos} of #{header.data_size}" }

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
          Log.trace { "Skipping a byte (#{io.peek[0]}) for #{name.i}" }
          io.seek 1, ::IO::Seek::Current
        end

        @extended_header,
        @extended_booleans,
        @extended_numbers,
        @extended_strings = parse_extended(io, @header.magic_number)
      end
    end

    # :nodoc:
    def parse_extended(io, magic_number)

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
      #      booleans_count: 2,
      #      numbers_count: 1,
      #      strings_count: 57,
      #      strings_table_items_count: 117,
      #      lastStrTableOffset: 680,
      #      total: 245 },

      header = ExtendedHeader.new io, magic_number

      # Booleans Section
      # One byte for each flag
      # Same order as <term.h>
      _booleans = [] of Bool?
      header.booleans_count.times do |i|
        b = read_i8le(io)
        _booleans.push b == 1
        Log.trace { "Boolean nr. #{i} (??? = #{b})" }
      end

      if (io.pos % 2)>0
        Log.trace { "Skipping a byte (#{io.peek[0]}) for #{name.i}" }
        io.seek 1, ::IO::Seek::Current
      end

      # Numbers Section
      _numbers = [] of Int32?
      header.numbers_count.times do |i|
        if @header.magic_number == 282
          n = ::Terminfo::TermImpl.read_i16le(io).to_i32
          n = -1 if n >= 65534 # Needed? Or just == 65535
        else
          n = ::Terminfo::TermImpl.read_i32le(io)
          #n = -1 if n >= 4294967294 # Needed? Or just == ...95? Or needed at all??
        end
        if n<-2
          raise Exception.new "Invalid number: #{n} (must be -2 <= n < max(int16/int32))"
        end
        _numbers.push (n>=0) ? n : nil
        Log.trace { "Number nr. #{i} (??? = #{n})" }
        #puts "#{v} = #{n}"
      end

      # Strings section
      #endpos = io.pos + header.symbol_offsets_size * 2 + header.strings_count * 2
      _strings = [] of Int16?
      header.strings_count.times do |i|
        offset = ::Terminfo::TermImpl.read_i16le(io)
        # Workaround: fix an odd bug in the screen-256color terminfo where it tries
        # to set -1, but it appears to have {0xfe, 0xff} (65534) instead of {0xff, 0xff} (65535).
        if offset>=65534
          offset=-1i16
        elsif offset<-1
          raise Exception.new "Invalid string offset: #{offset} (must be -2 <= offset < max(int16))"
        end

        Log.trace { "String nr. #{i} is at offset: #{offset}" }
        # Parsing is such that we always add this, but later check whether
        # the offset is valid or not.
        #_strings.push offset
        _strings.push (offset>=0) ? offset : nil
        #_strings.push offset if offset>=0
      end

      _symbols = [] of Int16?
      header.symbols_table_items_count.times do |i|
        offset = ::Terminfo::TermImpl.read_i16le(io)
        # Workaround: fix an odd bug in the screen-256color terminfo where it tries
        # to set -1, but it appears to have {0xfe, 0xff} (65534) instead of {0xff, 0xff} (65535).
        if offset>=65534
          offset=-1i16
        elsif offset<-1
          raise Exception.new "Invalid symbol offset: #{offset} (must be -2 <= offset < max(int16))"
        end

        Log.trace { "Symbol nr. #{i} is at offset: #{offset}" }
        _symbols.push (offset>=0) ? offset : nil
      end
      # Remember the pos we are at after having parsed the symbol offsets table
      pos = io.pos

      end_of_table = 0 # Index at which string table is done
      _strings2 = [] of String?
      _strings.each_with_index do |offset, i|
        if !offset || (offset < 0)
          _strings2.push nil
        else
          io.seek pos+offset, ::IO::Seek::Set
          v = io.gets(Char::ZERO,true) #|| ""
          _strings2.push v
          end_of_table = io.pos if io.pos > end_of_table
        end
        Log.trace { "String nr. #{i} (??? = #{v.inspect})" }
      end
      pos = io.pos

      end_of_table = 0 # Index at which symbol table is done
      _symbols2 = [] of String?
      _symbols.each_with_index do |offset, i|
        if !offset || (offset < 0)
        else
          io.seek pos+offset, ::IO::Seek::Set
          v = io.gets(Char::ZERO,true) #|| ""
          _symbols2.push v
          end_of_table = io.pos if io.pos > end_of_table
        end
        Log.trace { "Symbol nr. #{i} (#{v.inspect})" }
      end

      # Now all that's left to do is to pair symbol names to values, and to
      # update @capabilities with the new values.
      i = 0
      _booleans.each do |value|
        name=_symbols2[i].not_nil!
        next if value.nil?
        Log.trace { "Extended boolean #{name.i}=#{value.i})" }
        idx = @capabilities.booleans.indices[name]?
        if !idx
          idx = @capabilities.booleans.list.size
          @capabilities.booleans.list.push name
          @capabilities.booleans.indices[name] = idx
        end
        @booleans[idx.to_i16] = value
        i += 1
      end
      _numbers.each do |value|
        next if value.nil?
        name=_symbols2[i].not_nil!
        Log.trace { "Extended number #{name.i}=#{value.i})" }
        idx = @capabilities.numbers.indices[name]?
        if !idx
          idx = @capabilities.numbers.list.size
          @capabilities.numbers.list.push name
          @capabilities.numbers.indices[name] = idx
        end
        @numbers[idx.to_i16] = value
        i += 1
      end
      _strings2.each do |value|
        next if value.nil?
        name=_symbols2[i].not_nil!
        Log.trace { "Extended string #{name.i}=#{value.i})" }
        idx = @capabilities.strings.indices[name]?
        if !idx
          idx = @capabilities.strings.list.size
          @capabilities.strings.list.push name
          @capabilities.strings.indices[name] = idx
        end
        @strings[idx.to_i16] = value
        i += 1
      end

      p @booleans
      p @numbers
      p @strings

      # Don't do this; allow for erroneous null bytes at the end.
      #raise Exception.new("Not at end of file? Currently at #{io.pos}, should be at #{io.size}?") unless io.pos == io.size
      { header, booleans, numbers, strings }
    end

    # Conventional (non-extended) terminfo header data
    class Header
      property data_size : Int16
      property header_size : Int16
      property magic_number : Int16
      property names_size : Int16
      property booleans_count : Int16
      property numbers_count : Int16
      property strings_count : Int16
      property strings_table_byte_size : Int16
      property total_size : Int16

      def initialize(io : IO)
        @data_size      = io.size.to_i16
        @header_size    = 12
        @magic_number   = ::Terminfo::TermImpl.read_i16le(io) #(io[1] << 8) | io[0]

        # Magic number: 282 == 16-bit signed integers, 542 == 32-bit signed integers
        # 32-bit became possible in ncurses 6.1. The change affects the number array.
        unless [282, 542].includes? @magic_number
          raise Exception.new "Bad magic number; expecting: 282 or 542, got: #{@magic_number}"
        end

        @names_size     = ::Terminfo::TermImpl.read_i16le(io) #(io[3] << 8) | io[2]
        @booleans_count  = ::Terminfo::TermImpl.read_i16le(io) #(io[5] << 8) | io[4]
        @numbers_count   = ::Terminfo::TermImpl.read_i16le(io) #(io[7] << 8) | io[6]
        @strings_count   = ::Terminfo::TermImpl.read_i16le(io) #(io[9] << 8) | io[8]
        @strings_table_byte_size = ::Terminfo::TermImpl.read_i16le(io) #(io[11] << 8) | io[10]
        @total_size     = @header_size + @names_size + @booleans_count + @numbers_count*2 + @strings_count*2 + @strings_table_byte_size

        Log.debug { "Header: #{to_h.to_json}" }

        raise Exception.new "Invalid header section: names" if @names_size <= 0
        raise Exception.new "Invalid header section: booleans" if @booleans_count < 0
        raise Exception.new "Invalid header section: numbers" if @numbers_count < 0
        raise Exception.new "Invalid header section: strings" if @strings_count < 0
        raise Exception.new "Invalid header section size: strings" if @strings_table_byte_size < 0

        #raise Exception.new "Too many booleans" if @booleans_count > @booleans.size
        #raise Exception.new "Too many numbers" if @numbers_count > @numbers.size
        #raise Exception.new "Too many strings" if @strings_count > @strings.size
      end

      # Converts Terminfo header object to Hash
      def to_h
        {
          :data_size          => @data_size,
          :header_size        => @header_size,
          :magic_number       => @magic_number,
          :names_size         => @names_size,
          :booleans_count      => @booleans_count,
          :numbers_count       => @numbers_count,
          :strings_count       => @strings_count,
          :strings_table_byte_size => @strings_table_byte_size,
          :total_size         => @total_size,
        }
      end
    end

    # Extended terminfo header data
    class ExtendedHeader
      property header_size : Int16
      property magic_number : Int16
      property booleans_count : Int16
      property numbers_count : Int16
      property strings_count : Int16
      property strings_table_items_count : Int16
      property strings_table_byte_size : Int16
      property total_size : Int16
      property symbols_table_items_count : Int16

      def initialize(io : IO, @magic_number)
        Log.trace { "Initializing extended header for #{io.i}" }
        @header_size            = 10
        @booleans_count         = ::Terminfo::TermImpl.read_i16le(io)
        Log.trace { "Booleans count: #{@booleans_count}" }
        @numbers_count          = ::Terminfo::TermImpl.read_i16le(io)
        Log.trace { "Numbers count: #{@numbers_count}" }
        @strings_count          = ::Terminfo::TermImpl.read_i16le(io)
        Log.trace { "Strings count: #{@strings_count}" }
        @strings_table_items_count    = ::Terminfo::TermImpl.read_i16le(io)
        @strings_table_byte_size = ::Terminfo::TermImpl.read_i16le(io)
        @symbols_table_items_count    = @booleans_count + @numbers_count + @strings_count
        @total_size            = @header_size + @booleans_count + @numbers_count*(@magic_number==282 ? 2 : 4) + @strings_count*2 + (@symbols_table_items_count*2) + @strings_table_byte_size
        Log.debug { "Extended header: #{to_h.to_json}" }

        #raise Exception.new "Invalid header section: booleans" if @booleans_count < 0
        #raise Exception.new "Invalid header section: numbers" if @numbers_count < 0
        #raise Exception.new "Invalid header section: strings" if @strings_count < 0
        #raise Exception.new "Invalid header section size: strings" if @strings_table_items_count < 0
      end

      # Converts extended Terminfo header object to Hash
      def to_h
        {
          :header_size         => @header_size,
          :booleans_count       => @booleans_count,
          :numbers_count        => @numbers_count,
          :strings_count        => @strings_count,
          :strings_table_items_count  => @strings_table_items_count,
          :strings_table_byte_size => @strings_table_byte_size,
          #:symbol_offsets_size => @symbol_offsets_size,
          :total_size          => @total_size,
        }
      end
    end

    macro read_i32le(io)
      x = io.read_bytes(Int32, IO::ByteFormat::LittleEndian)
      #Log.trace { "Reading 32-bit LE int: #{x}" }
      x
    end
    macro read_i16le(io)
      x = io.read_bytes(Int16, IO::ByteFormat::LittleEndian)
      #Log.trace { "Reading 16-bit LE int: #{x}" }
      x
    end
    macro read_i8le(io)
      x = io.read_bytes(Int8, IO::ByteFormat::LittleEndian)
      #Log.trace { "Reading 8-bit LE int: #{x}" }
      x
    end

    def boolean(arg : String) @booleans[@capabilities.booleans.indices[arg]] end
    def boolean?(arg : String) @booleans[@capabilities.booleans.indices[arg]?]? end
    def boolean!(arg : String) @booleans[@capabilities.booleans.indices[arg].not_nil!].not_nil! end
    def boolean(arg : Int) @booleans[arg] end
    def boolean?(arg : Int) @booleans[arg]? end
    def boolean!(arg : Int) @booleans[arg].not_nil! end

    def number(arg : String) @numbers[@capabilities.numbers.indices[arg]] end
    def number?(arg : String) @numbers[@capabilities.numbers.indices[arg]?]? end
    def number!(arg : String) @numbers[@capabilities.numbers.indices[arg].not_nil!].not_nil! end
    def number(arg : Int) @numbers[arg] end
    def number?(arg : Int) @numbers[arg]? end
    def number!(arg : Int) @numbers[arg].not_nil! end

    def string(arg : String) @strings[@capabilities.strings.indices[arg]] end
    def string?(arg : String) @strings[@capabilities.strings.indices[arg]?]? end
    def string!(arg : String) @strings[@capabilities.strings.indices[arg].not_nil!].not_nil! end
    def string(arg : Int) @strings[arg] end
    def string?(arg : Int) @strings[arg]? end
    def string!(arg : Int) @strings[arg].not_nil! end
  end

  class Term
    include TermImpl
  end
end
