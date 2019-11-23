require "baked_file_system"

require "./alias"

module Terminfo
  VERSION = "0.6.0"

  extend BakedFileSystem
  bake_folder "../filesystem/"

  # List of default directories to search for terminfo files
  class_property directories = [] of String

  # Terminfo extended parsing flag. If this flag is true and
  # extended sections exist in terminfo files, they will be
  # parsed.
  class_property? extended = true

  (i=ENV["TERMINFO"]?).try      do |i| @@directories.push i end
  (i=ENV["TERMINFO_DIRS"]?).try do |i| @@directories += i.split ':' end
  (i=ENV["HOME"]?).try          do |i| @@directories.push i + "/.terminfo" end
  @@directories.push \
    "/usr/share/terminfo",
    "/usr/share/lib/terminfo",
    "/usr/lib/terminfo",
    "/usr/local/share/terminfo",
    "/usr/local/share/lib/terminfo",
    "/usr/local/lib/terminfo",
    "/usr/local/ncurses/lib/terminfo",
    "/lib/terminfo"

  # All supported boolean capabilities/functions.
  # This list is somewhat larger than the list of capabilities in `src/alias.cr`
  # due to extra additions.
  Booleans = [
    "auto_left_margin",
    "auto_right_margin",
    "no_esc_ctlc",
    "ceol_standout_glitch",
    "eat_newline_glitch",
    "erase_overstrike",
    "generic_type",
    "hard_copy",
    "has_meta_key",
    "has_status_line",
    "insert_null_glitch",
    "memory_above",
    "memory_below",
    "move_insert_mode",
    "move_standout_mode",
    "over_strike",
    "status_line_esc_ok",
    "dest_tabs_magic_smso",
    "tilde_glitch",
    "transparent_underline",
    "xon_xoff",
    "needs_xon_xoff",
    "prtr_silent",
    "hard_cursor",
    "non_rev_rmcup",
    "no_pad_char",
    "non_dest_scroll_region",
    "can_change",
    "back_color_erase",
    "hue_lightness_saturation",
    "col_addr_glitch",
    "cr_cancels_micro_mode",
    "has_print_wheel",
    "row_addr_glitch",
    "semi_auto_right_margin",
    "cpi_changes_res",
    "lpi_changes_res",
    # #ifdef __INTERNAL_CAPS_VISIBLE
    "backspaces_with_bs",
    "crt_no_scrolling",
    "no_correctly_working_cr",
    "gnu_has_meta_key",
    "linefeed_is_newline",
    "has_hardware_tabs",
    "return_does_clr_eol",
  ]

  # All supported numeric capabilities/functions.
  # This list is somewhat larger than the list of capabilities in `src/alias.cr`
  # due to extra additions.
  Numbers = [
    "columns",
    "init_tabs",
    "lines",
    "lines_of_memory",
    "magic_cookie_glitch",
    "padding_baud_rate",
    "virtual_terminal",
    "width_status_line",
    "num_labels",
    "label_height",
    "label_width",
    "max_attributes",
    "maximum_windows",
    "max_colors",
    "max_pairs",
    "no_color_video",
    "buffer_capacity",
    "dot_vert_spacing",
    "dot_horz_spacing",
    "max_micro_address",
    "max_micro_jump",
    "micro_col_size",
    "micro_line_size",
    "number_of_pins",
    "output_res_char",
    "output_res_line",
    "output_res_horz_inch",
    "output_res_vert_inch",
    "print_rate",
    "wide_char_size",
    "buttons",
    "bit_image_entwining",
    "bit_image_type",
    # #ifdef __INTERNAL_CAPS_VISIBLE
    "magic_cookie_glitch_ul",
    "carriage_return_delay",
    "new_line_delay",
    "backspace_delay",
    "horizontal_tab_delay",
    "number_of_function_keys",
  ]

  # All supported string capabilities/functions.
  # This list is somewhat larger than the list of capabilities in `src/alias.cr`
  # due to extra additions.
  Strings = [
    "back_tab",
    "bell",
    "carriage_return",
    "change_scroll_region",
    "clear_all_tabs",
    "clear_screen",
    "clr_eol",
    "clr_eos",
    "column_address",
    "command_character",
    "cursor_address",
    "cursor_down",
    "cursor_home",
    "cursor_invisible",
    "cursor_left",
    "cursor_mem_address",
    "cursor_normal",
    "cursor_right",
    "cursor_to_ll",
    "cursor_up",
    "cursor_visible",
    "delete_character",
    "delete_line",
    "dis_status_line",
    "down_half_line",
    "enter_alt_charset_mode",
    "enter_blink_mode",
    "enter_bold_mode",
    "enter_ca_mode",
    "enter_delete_mode",
    "enter_dim_mode",
    "enter_insert_mode",
    "enter_secure_mode",
    "enter_protected_mode",
    "enter_reverse_mode",
    "enter_standout_mode",
    "enter_underline_mode",
    "erase_chars",
    "exit_alt_charset_mode",
    "exit_attribute_mode",
    "exit_ca_mode",
    "exit_delete_mode",
    "exit_insert_mode",
    "exit_standout_mode",
    "exit_underline_mode",
    "flash_screen",
    "form_feed",
    "from_status_line",
    "init_1string",
    "init_2string",
    "init_3string",
    "init_file",
    "insert_character",
    "insert_line",
    "insert_padding",
    "key_backspace",
    "key_catab",
    "key_clear",
    "key_ctab",
    "key_dc",
    "key_dl",
    "key_down",
    "key_eic",
    "key_eol",
    "key_eos",
    "key_f0",
    "key_f1",
    "key_f10",
    "key_f2",
    "key_f3",
    "key_f4",
    "key_f5",
    "key_f6",
    "key_f7",
    "key_f8",
    "key_f9",
    "key_home",
    "key_ic",
    "key_il",
    "key_left",
    "key_ll",
    "key_npage",
    "key_ppage",
    "key_right",
    "key_sf",
    "key_sr",
    "key_stab",
    "key_up",
    "keypad_local",
    "keypad_xmit",
    "lab_f0",
    "lab_f1",
    "lab_f10",
    "lab_f2",
    "lab_f3",
    "lab_f4",
    "lab_f5",
    "lab_f6",
    "lab_f7",
    "lab_f8",
    "lab_f9",
    "meta_off",
    "meta_on",
    "newline",
    "pad_char",
    "parm_dch",
    "parm_delete_line",
    "parm_down_cursor",
    "parm_ich",
    "parm_index",
    "parm_insert_line",
    "parm_left_cursor",
    "parm_right_cursor",
    "parm_rindex",
    "parm_up_cursor",
    "pkey_key",
    "pkey_local",
    "pkey_xmit",
    "print_screen",
    "prtr_off",
    "prtr_on",
    "repeat_char",
    "reset_1string",
    "reset_2string",
    "reset_3string",
    "reset_file",
    "restore_cursor",
    "row_address",
    "save_cursor",
    "scroll_forward",
    "scroll_reverse",
    "set_attributes",
    "set_tab",
    "set_window",
    "tab",
    "to_status_line",
    "underline_char",
    "up_half_line",
    "init_prog",
    "key_a1",
    "key_a3",
    "key_b2",
    "key_c1",
    "key_c3",
    "prtr_non",
    "char_padding",
    "acs_chars",
    "plab_norm",
    "key_btab",
    "enter_xon_mode",
    "exit_xon_mode",
    "enter_am_mode",
    "exit_am_mode",
    "xon_character",
    "xoff_character",
    "ena_acs",
    "label_on",
    "label_off",
    "key_beg",
    "key_cancel",
    "key_close",
    "key_command",
    "key_copy",
    "key_create",
    "key_end",
    "key_enter",
    "key_exit",
    "key_find",
    "key_help",
    "key_mark",
    "key_message",
    "key_move",
    "key_next",
    "key_open",
    "key_options",
    "key_previous",
    "key_print",
    "key_redo",
    "key_reference",
    "key_refresh",
    "key_replace",
    "key_restart",
    "key_resume",
    "key_save",
    "key_suspend",
    "key_undo",
    "key_sbeg",
    "key_scancel",
    "key_scommand",
    "key_scopy",
    "key_screate",
    "key_sdc",
    "key_sdl",
    "key_select",
    "key_send",
    "key_seol",
    "key_sexit",
    "key_sfind",
    "key_shelp",
    "key_shome",
    "key_sic",
    "key_sleft",
    "key_smessage",
    "key_smove",
    "key_snext",
    "key_soptions",
    "key_sprevious",
    "key_sprint",
    "key_sredo",
    "key_sreplace",
    "key_sright",
    "key_srsume",
    "key_ssave",
    "key_ssuspend",
    "key_sundo",
    "req_for_input",
    "key_f11",
    "key_f12",
    "key_f13",
    "key_f14",
    "key_f15",
    "key_f16",
    "key_f17",
    "key_f18",
    "key_f19",
    "key_f20",
    "key_f21",
    "key_f22",
    "key_f23",
    "key_f24",
    "key_f25",
    "key_f26",
    "key_f27",
    "key_f28",
    "key_f29",
    "key_f30",
    "key_f31",
    "key_f32",
    "key_f33",
    "key_f34",
    "key_f35",
    "key_f36",
    "key_f37",
    "key_f38",
    "key_f39",
    "key_f40",
    "key_f41",
    "key_f42",
    "key_f43",
    "key_f44",
    "key_f45",
    "key_f46",
    "key_f47",
    "key_f48",
    "key_f49",
    "key_f50",
    "key_f51",
    "key_f52",
    "key_f53",
    "key_f54",
    "key_f55",
    "key_f56",
    "key_f57",
    "key_f58",
    "key_f59",
    "key_f60",
    "key_f61",
    "key_f62",
    "key_f63",
    "clr_bol",
    "clear_margins",
    "set_left_margin",
    "set_right_margin",
    "label_format",
    "set_clock",
    "display_clock",
    "remove_clock",
    "create_window",
    "goto_window",
    "hangup",
    "dial_phone",
    "quick_dial",
    "tone",
    "pulse",
    "flash_hook",
    "fixed_pause",
    "wait_tone",
    "user0",
    "user1",
    "user2",
    "user3",
    "user4",
    "user5",
    "user6",
    "user7",
    "user8",
    "user9",
    "orig_pair",
    "orig_colors",
    "initialize_color",
    "initialize_pair",
    "set_color_pair",
    "set_foreground",
    "set_background",
    "change_char_pitch",
    "change_line_pitch",
    "change_res_horz",
    "change_res_vert",
    "define_char",
    "enter_doublewide_mode",
    "enter_draft_quality",
    "enter_italics_mode",
    "enter_leftward_mode",
    "enter_micro_mode",
    "enter_near_letter_quality",
    "enter_normal_quality",
    "enter_shadow_mode",
    "enter_subscript_mode",
    "enter_superscript_mode",
    "enter_upward_mode",
    "exit_doublewide_mode",
    "exit_italics_mode",
    "exit_leftward_mode",
    "exit_micro_mode",
    "exit_shadow_mode",
    "exit_subscript_mode",
    "exit_superscript_mode",
    "exit_upward_mode",
    "micro_column_address",
    "micro_down",
    "micro_left",
    "micro_right",
    "micro_row_address",
    "micro_up",
    "order_of_pins",
    "parm_down_micro",
    "parm_left_micro",
    "parm_right_micro",
    "parm_up_micro",
    "select_char_set",
    "set_bottom_margin",
    "set_bottom_margin_parm",
    "set_left_margin_parm",
    "set_right_margin_parm",
    "set_top_margin",
    "set_top_margin_parm",
    "start_bit_image",
    "start_char_set_def",
    "stop_bit_image",
    "stop_char_set_def",
    "subscript_characters",
    "superscript_characters",
    "these_cause_cr",
    "zero_motion",
    "char_set_names",
    "key_mouse",
    "mouse_info",
    "req_mouse_pos",
    "get_mouse",
    "set_a_foreground",
    "set_a_background",
    "pkey_plab",
    "device_type",
    "code_set_init",
    "set0_des_seq",
    "set1_des_seq",
    "set2_des_seq",
    "set3_des_seq",
    "set_lr_margin",
    "set_tb_margin",
    "bit_image_repeat",
    "bit_image_newline",
    "bit_image_carriage_return",
    "color_names",
    "define_bit_image_region",
    "end_bit_image_region",
    "set_color_band",
    "set_page_length",
    "display_pc_char",
    "enter_pc_charset_mode",
    "exit_pc_charset_mode",
    "enter_scancode_mode",
    "exit_scancode_mode",
    "pc_term_options",
    "scancode_escape",
    "alt_scancode_esc",
    "enter_horizontal_hl_mode",
    "enter_left_hl_mode",
    "enter_low_hl_mode",
    "enter_right_hl_mode",
    "enter_top_hl_mode",
    "enter_vertical_hl_mode",
    "set_a_attributes",
    "set_pglen_inch",
    # #ifdef __INTERNAL_CAPS_VISIBLE
    "termcap_init2",
    "termcap_reset",
    "linefeed_if_not_lf",
    "backspace_if_not_bs",
    "other_non_function_keys",
    "arrow_key_map",
    "acs_ulcorner",
    "acs_llcorner",
    "acs_urcorner",
    "acs_lrcorner",
    "acs_ltee",
    "acs_rtee",
    "acs_btee",
    "acs_ttee",
    "acs_hline",
    "acs_vline",
    "acs_plus",
    "memory_lock",
    "memory_unlock",
    "box_chars_1",
  ]

  # Checks whether *term* exists in the module's built-in storage.
  def self.has_internal?(term) !! get? term end

  # Retrieves *term* from module's built-in storage.
  #
  # It returns BakedFileSystem::BakedFile. To read full contents,
  # call `#read` on the object.
  def self.get_internal(term) get term end

  # Retrieves *term* from module's built-in storage or nil if
  # it is not found.
  #
  # It returns BakedFileSystem::BakedFile. To read full contents,
  # call `#read` on the object.
  def self.get_internal?(term) get? term end

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
  property booleans : Hash(String,Bool)
  # List of numeric capabilities
  property numbers : Hash(String,Int16)
  # List of string capabilities
  property strings : Hash(String,String)

  # Contents of extended terminfo file header
  property extended_header : ExtendedHeader?
  # List of boolean capabilities from extended data
  property booleans : Hash(String,Bool)
  property extended_booleans : Hash(String,Bool)
  # List of numeric capabilities from extended data
  property extended_numbers : Hash(String,Int16)
  # List of string capabilities from extended data
  property extended_strings : Hash(String,String)

  # Create Terminfo object
  def initialize(*, path : String)
    File.open(path) do |io| initialize path, io end
  end
  # :ditto:
  def initialize(*, builtin : String)
    initialize ::Terminfo.get_internal builtin
  end
  # :ditto:
  def initialize(*, term : String)
    filename = nil
    ::Terminfo.directories.each do |dir|
      f1 = File.join dir, term
      f2 = File.join dir, term[0..0], term[0..1], term
      filename = nil
      if File.readable? f1
        filename = f1
        break
      elsif File.readable? f2
        filename = f2
        break
      end
      if filename
        initialize path: filename
      else
        f = ::Terminfo.get_internal? term
        if f
          initialize file: f
        else
          raise Exception.new "Can't find system or builtin terminfo file for '#{term}'"
        end
      end
    end
  end
  # :ditto:
  def initialize
    if filename = ENV["TERMINFO"]?
      initialize path: filename
    elsif term = ENV["TERM"]?
      initialize term: term
    else
      initialize builtin: "{% if flag?(:windows) %}windows-ansi{% else %}xterm{% end %}"
    end
  end

  # :ditto:
  def initialize(file : BakedFileSystem::BakedFile)
    initialize file, ::IO::Memory.new file.read
  end
  # :ditto:
  def initialize(file : File)
    initialize file
  end

  # :ditto:
  def initialize(file, io : IO, extended = ::Terminfo.extended?)

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
    @booleans = Hash(String,Bool).new
    @header.booleans_size.times do |i|
      @booleans[Booleans[i]] = io.read_bytes(Int8, IO::ByteFormat::LittleEndian) == 1
    end

    if (io.pos % 2)>0
      # Null byte in between to make sure numbers begin on an even byte.
      io.seek 1, ::IO::Seek::Current
    end

    # Numbers Section
    @numbers = Hash(String,Int16).new
    @header.numbers_size.times do |i|
      n = io.read_bytes(Int16, IO::ByteFormat::LittleEndian)
      n=-1i16 if n == 65535 # XXX or n>= 65533 ?
      @numbers[Numbers[i]] = n
      #puts "#{v} = #{n}"
    end

    if (io.pos % 2)>0
      # Null byte in between to make sure numbers begin on an even byte.
      io.seek 1, ::IO::Seek::Current
    end

    # Strings section. This section contains offsets, which then need to be read.
    endpos = io.pos + header.strings_size * 2
    @strings = Hash(String,String).new
    @header.strings_size.times do |i|
      k = Strings[i]
      offset = io.read_bytes(Int16, IO::ByteFormat::LittleEndian)
      pos = io.pos
      # Workaround: fix an odd bug in the screen-256color terminfo where it tries
      # to set -1, but it appears to have {0xfe, 0xff} (65534) instead of {0xff, 0xff} (65535).
      if offset<65534
        io.seek endpos+offset, ::IO::Seek::Set
        @strings[k] = io.gets(Char::ZERO, true) || ""
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
    _booleans = [] of Bool
    header.booleans_size.times do |i|
      _booleans.push io.read_bytes(Int8, IO::ByteFormat::LittleEndian) == 1
    end

    if (io.pos % 2)>0
      io.seek 1, ::IO::Seek::Current
    end

    # Numbers Section
    _numbers = [] of Int16
    header.numbers_size.times do |i|
      n = io.read_bytes(Int16, IO::ByteFormat::LittleEndian)
      n=-1i16 if n == 65535 # XXX or > 65533 ?
      _numbers.push n
      #puts "#{v} = #{n}"
    end

    # Strings section
    # TODO combine these 2 blocks into one
    endpos = io.pos + header.symbol_offsets_size * 2 + header.strings_size * 2
    _strings = [] of Int16
    header.strings_size.times do |i|
      offset = io.read_bytes(Int16, IO::ByteFormat::LittleEndian)
      # Workaround: fix an odd bug in the screen-256color terminfo where it tries
      # to set -1, but it appears to have {0xfe, 0xff} (65534) instead of {0xff, 0xff} (65535).
      if offset<65534
        _strings.push offset
      else
        _strings.push -1
      end
    end
    # Both are alternative ways and work:
    #p io.size - header.lastStrTableOffset
    #p io.pos + header.symOffsetCount*2
    io.seek (io.pos + header.symbol_offsets_size*2), ::IO::Seek::Set
    # Remember the pos we are at after having parsed the offsets table
    pos = io.pos
    high = 0 # Index at which string table is done
    _strings2 = [] of String
    _strings.each do |offset|
      if offset == -1
         # XXX or just next?
        _strings2.push ""
      else
        io.seek pos+offset, ::IO::Seek::Set
        _strings2.push io.gets(Char::ZERO,true) || ""
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

    booleans = {} of String => Bool
    _booleans.each do |bool|
      booleans[symbols[j]] = bool
      j+=1
    end

    numbers = {} of String => Int16
    _numbers.each do |number|
      numbers[symbols[j]] = number
      j+=1
    end

    strings = {} of String => String
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
      @magic_number   = io.read_bytes(Int16, IO::ByteFormat::LittleEndian) #(io[1] << 8) | io[0]
      @names_size     = io.read_bytes(Int16, IO::ByteFormat::LittleEndian) #(io[3] << 8) | io[2]
      @booleans_size     = io.read_bytes(Int16, IO::ByteFormat::LittleEndian) #(io[5] << 8) | io[4]
      @numbers_size   = io.read_bytes(Int16, IO::ByteFormat::LittleEndian) #(io[7] << 8) | io[6]
      @strings_size   = io.read_bytes(Int16, IO::ByteFormat::LittleEndian) #(io[9] << 8) | io[8]
      @strings_table_size = io.read_bytes(Int16, IO::ByteFormat::LittleEndian) #(io[11] << 8) | io[10]
      @total_size     = @header_size + @names_size + @booleans_size + @numbers_size*2 + @strings_size*2 + @strings_table_size
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
      @booleans_size         = io.read_bytes(Int16, IO::ByteFormat::LittleEndian)
      @numbers_size          = io.read_bytes(Int16, IO::ByteFormat::LittleEndian)
      @strings_size          = io.read_bytes(Int16, IO::ByteFormat::LittleEndian)
      @strings_table_size    = io.read_bytes(Int16, IO::ByteFormat::LittleEndian)
      @last_strings_table_offset = io.read_bytes(Int16, IO::ByteFormat::LittleEndian)
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

  # Represents complete terminfo data.
  #
  # This class should be used when a Terminfo class is preferred
  # over using a module.
  class Data
    include ::Terminfo
  end
end
