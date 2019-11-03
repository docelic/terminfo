require "../src/alias"

# Resources:
#   $ man term
#   $ man terminfo
#   http://invisible-island.net/ncurses/man/term.5.html
#   https://en.wikipedia.org/wiki/Terminfo
#
# Todo:
# - xterm's XT (set-title capability?) value should
#   be true (at least tmux thinks it should).
#   It's not parsed as true. Investigate.
# - Possibly switch to other method of finding the
#   extended data string table: i += h.symOffsetCount * 2

module Crysterm
  DIR= "."

  class Tput

    # Terminfo booleans
    Bools = [
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

    # Terminfo numbers
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

    # Terminfo strings
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

    # DEC Special Character and Line Drawing Set.
    # Taken from tty.js.
    Acsc = {    # (0
      "`": "\u25c6", # "◆"
      "a": "\u2592", # "▒"
      "b": "\u0009", # "\t"
      "c": "\u000c", # "\f"
      "d": "\u000d", # "\r"
      "e": "\u000a", # "\n"
      "f": "\u00b0", # "°"
      "g": "\u00b1", # "±"
      "h": "\u2424", # "\u2424" (NL)
      "i": "\u000b", # "\v"
      "j": "\u2518", # "┘"
      "k": "\u2510", # "┐"
      "l": "\u250c", # "┌"
      "m": "\u2514", # "└"
      "n": "\u253c", # "┼"
      "o": "\u23ba", # "⎺"
      "p": "\u23bb", # "⎻"
      "q": "\u2500", # "─"
      "r": "\u23bc", # "⎼"
      "s": "\u23bd", # "⎽"
      "t": "\u251c", # "├"
      "u": "\u2524", # "┤"
      "v": "\u2534", # "┴"
      "w": "\u252c", # "┬"
      "x": "\u2502", # "│"
      "y": "\u2264", # "≤"
      "z": "\u2265", # "≥"
      "{": "\u03c0", # "π"
      "|": "\u2260", # "≠"
      "}": "\u00a3", # "£"
      "~": "\u00b7"  # "·"
    }

    # Convert ACS unicode characters to the
    # most similar-looking ascii characters.
    Utoa= {
      "\u25c6": "*", # "◆"
      "\u2592": " ", # "▒"
      # "\u0009": "\t", # "\t"
      # "\u000c": "\f", # "\f"
      # "\u000d": "\r", # "\r"
      # "\u000a": "\n", # "\n"
      "\u00b0": "*", # "°"
      "\u00b1": "+", # "±"
      "\u2424": "\n", # "\u2424" (NL)
      # "\u000b": "\v", # "\v"
      "\u2518": "+", # "┘"
      "\u2510": "+", # "┐"
      "\u250c": "+", # "┌"
      "\u2514": "+", # "└"
      "\u253c": "+", # "┼"
      "\u23ba": "-", # "⎺"
      "\u23bb": "-", # "⎻"
      "\u2500": "-", # "─"
      "\u23bc": "-", # "⎼"
      "\u23bd": "_", # "⎽"
      "\u251c": "+", # "├"
      "\u2524": "+", # "┤"
      "\u2534": "+", # "┴"
      "\u252c": "+", # "┬"
      "\u2502": "|", # "│"
      "\u2264": "<", # "≤"
      "\u2265": ">", # "≥"
      "\u03c0": "?", # "π"
      "\u2260": "=", # "≠"
      "\u00a3": "?", # "£"
      "\u00b7": "*"  # "·"
    }

    # Fallback Termcap Entry
    Termcap =
      "vt102|dec vt102:" +
      ":do=^J:co#80:li#24:cl=50\\E[;H\\E[2J:" +
      ":le=^H:bs:cm=5\\E[%i%d;%dH:nd=2\\E[C:up=2\\E[A:" +
      ":ce=3\\E[K:cd=50\\E[J:so=2\\E[7m:se=2\\E[m:us=2\\E[4m:ue=2\\E[m:" +
      ":md=2\\E[1m:mr=2\\E[7m:mb=2\\E[5m:me=2\\E[m:is=\\E[1;24r\\E[24;1H:" +
      ":rs=\\E>\\E[?3l\\E[?4l\\E[?5l\\E[?7h\\E[?8h:ks=\\E[?1h\\E=:ke=\\E[?1l\\E>:" +
      ":ku=\\EOA:kd=\\EOB:kr=\\EOC:kl=\\EOD:kb=^H:\\\n" +
      ":ho=\\E[H:k1=\\EOP:k2=\\EOQ:k3=\\EOR:k4=\\EOS:pt:sr=5\\EM:vt#3:" +
      ":sc=\\E7:rc=\\E8:cs=\\E[%i%d;%dr:vs=\\E[?7l:ve=\\E[?7h:" +
      ":mi:al=\\E[L:dc=\\E[P:dl=\\E[M:ei=\\E[4l:im=\\E[4h:"

    Alias = {} of String => Hash(String,String)
    AliasMap = {} of String => String
    All = {} of String => String

    # XXX Why all these aren't fixed lists?
    ::Crysterm::Alias::Bools.each do   |key, value| Alias[key] = {"terminfo" => value[0], "termcap" => value[1]} end
    ::Crysterm::Alias::Numbers.each do |key, value| Alias[key] = {"terminfo" => value[0], "termcap" => value[1]} end
    ::Crysterm::Alias::Strings.each do |key, value| Alias[key] = {"terminfo" => value[0], "termcap" => value[1]} end
    # TODO
    #Tput.alias.no_esc_ctlc.push('beehive_glitch')
    #Tput.alias.dest_tabs_magic_smso.push('teleray_glitch')
    #Tput.alias.micro_col_size.push('micro_char_size')
    # TODO some keys missing here?
    #Alias.each do |key, value|
    #  AliasMap[key] = key
    #  AliasMap[key["terminfo"]] = key
    #  AliasMap[key["termcap"]] = key
    #end

    Ipaths = [
      "/usr/share/terminfo",
      "/usr/share/lib/terminfo",
      "/usr/lib/terminfo",
      "/usr/local/share/terminfo",
      "/usr/local/share/lib/terminfo",
      "/usr/local/lib/terminfo",
      "/usr/local/ncurses/lib/terminfo",
      "/lib/terminfo"
    ]
    # Addition 1
    Ipaths.unshift (ENV["HOME"]? || "")+ "/.terminfo"
    # Addition 2
    if ENV["TERMINFO_DIRS"]?
      dirs = ENV["TERMINFO_DIRS"].split(":")
      dirs.reverse.each { |d| Ipaths.unshift d }
    end
    # Addition 3
    if ENV["TERMINFO"]?; Ipaths.insert 0, ENV["TERMINFO"] end

    @terminal : String
    @debug : Bool
    @padding : Int32?
    @extended : Bool
    @printf : Int32?
    @termcap : Int32?
    getter error : Exception?
    @terminfo_prefix : String?
    @terminfo_file : String?
    @termcap_file : String?
    @force_unicode : Bool

    def initialize(
      # TODO adjust these defaults below and types above
      @terminal = ::Crysterm::Helpers.find_terminal,
      @debug = false,
      @padding = 0,
      @extended = true,
      @termcap = 0,
      @terminfo_prefix = "",
      @terminfo_file = "",
      @termcap_file = "",
      @force_unicode = detect_unicode,
    )

      # XXX this is called even if terminal is initialized from ENV variable.
      # In Blessed, it is called only if terminal is explicitly passed in options.
      if @terminal
        setup
      end
    end

    def setup
      @error = nil

      begin
        if @termcap
          begin
            inject_termcap
          rescue e : Exception
            raise e if @debug
            @error = Exception.new("Termcap parse error.")
            _use_internal_cap(@terminal)
          end
        else
          begin
            inject_terminfo
          rescue e : Exception
            raise e if @debug
            @error = Exception.new("Terminfo parse error.")
            _use_internal_info(@terminal)
          end
        end
      rescue e : Exception
        raise e if @debug
        @error = Exception.new("Terminfo not found.")
        _use_xterm_info
      end
    end

    def term(is)
      @_terminal[0..(is.size-1)] == is
    end

    # TODO
    def inject_termcap(term=@terminal)
    end
    def inject_terminfo(term=@terminal)
      inject compile_terminfo term
    end
    def _use_internal_cap(term)
      inject_termcap DIR+"/../usr/"+File.basename(term)+".termcap"
    end
    def _use_internal_info(term)
      inject_terminfo DIR+"/../usr/"+File.basename(term)
    end
    def _use_xterm_cap
      inject_termcap DIR+"/../usr/xterm.termcap"
    end
    def _use_xterm_info
      inject_terminfo DIR+"/../usr/xterm"
    end
    def _use_vt102_cap
      inject_termcap "vt102"
    end

    def read_terminfo(term=@terminal)
      file = _prefix(term).not_nil!
      info = parse_terminfo file

      if @debug
        _terminfo = info
      end

      info
    end

    def _prefix(term= nil)
      puts term
      # If we have a terminfoFile, or our
      # term looks like a filename, use it.
      if term
        if term.index File::SEPARATOR
          return term
        end
        if @terminfo_file
          return @terminfo_file
        end
      end

      paths= Ipaths.dup

      if (d= @terminfo_prefix)
        paths.unshift d
      end

      # Try exact matches.
      file = _tprefix(paths, term)
      return file if file

      # Try similar matches.
      file = _tprefix(paths, term, true)
      return file if file

      # Not found.
      raise Exception.new("Terminfo directory not found.")
    end

    def _tprefix(prefix : Array, term, soft= false)
      prefix.each do |pref|
        file = _tprefix(pref, term, soft)
        return file if file
      end
      nil
    end
    # TODO implement/fix when we come to that.
    def _tprefix(prefix, term, soft= false)
      if (!prefix)
        return
      end

      sfile= nil
      sdiff= 0

      if (!term)
        # Make sure the directory's sub-directories
        # are all one-letter, or hex digits.
        # return find('x') ? prefix : nil
        begin
          dir = Dir.children prefix

          dir= dir.select { |file|
            # NOTE file.size refers to filename length, not file contents length
            ( file.size != 1) && !( file=~ /^[0-9a-fA-F]{2}$/)
          }
          if (dir.size== 0)
            return prefix
          end
        rescue e : Exception
        end
        return
      end

      term = File.basename(term)
      #dir = find(prefix, term)

      if (!dir)
        return
      end

      if (soft)
        begin
          list = Dir.entries dir
          list.delete "."
          list.delete ".."
        rescue e : Exception
          return
        end

        list.each do |file|
          if (file.index(term) == 0)
            diff = file.size - term.size
            if (!sfile || diff < sdiff)
              sdiff = diff
              sfile = file
            end
          end
        end

        # XXX path.resolve
        return sfile && (soft || sdiff == 0) ? File.join(dir, sfile) : nil
      end

      file = resolve(dir, term)
      begin
        File.stat(file)
        return file
      rescue e : Exception
      end
      nil
    end

    # Checks whether terminal feature exists
    def has(name)
      name = AliasMap[name]?
      return unless name

      val = All[name]

      if val.is_a? Int
        val != -1
      else
        !!val
      end
    end

    def write(data)
      # TODO maybe .to_slice?
      STDOUT.write data
    end

    def noop
      ""
    end

    # Chuckle
    def get_console_cp
      {% if flag? :unix %}return{% end %}
      raise Exception.new "Not implemented"
      # TODO
    end

    def detect_unicode
      unless ENV["NCURSES_FORCE_UNICODE"]?.nil?
        return ENV["NCURSES_FORCE_UNICODE"]==1
      end

      str = [ ENV["LANG"]?, ENV["LANGUAGE"]?, ENV["LC_ALL"]?, ENV["LC_CTYPE"]? ].join ':'
      str =~ /utf\-?8/ ? true : false # TODO || (get_console_cp == 65001)
    end

    # XXX These as now coded do not support setting env var to 0.
    # As soon as they're defined, they imply 1.
    def detectMagicCookie; ENV["NCURSES_NO_MAGIC_COOKIE"]?.nil?  end
    def detectPadding; ENV["NCURSES_NO_PADDING"]?.nil?  end
    def detectSetbuf; ENV["NCURSES_NO_SETBUF"]?.nil?  end


    # Terminfo Parser
    # All shorts are little-endian
    #
    #alias TerminfoType = String | Int32 | UInt64 | Hash(String, Int32 | UInt64 | UInt16) | Array(String) | Hash(String, Bool) | Hash(String, UInt16) | Hash(String,String)
    #alias TerminfoType = Int32 | UInt16 | UInt64
    def parse_terminfo(file)
      i = 0

      File.open(file) do |data|

        # HEADER
        h= {
          "dataSize"     => data.size,
          "headerSize"   => 12,
          "magicNumber"  => data.read_bytes(UInt16, IO::ByteFormat::LittleEndian), #(data[1] << 8) | data[0],
          "namesSize"    => data.read_bytes(UInt16, IO::ByteFormat::LittleEndian), #(data[3] << 8) | data[2],
          "boolCount"    => data.read_bytes(UInt16, IO::ByteFormat::LittleEndian), #(data[5] << 8) | data[4],
          "numCount"     => data.read_bytes(UInt16, IO::ByteFormat::LittleEndian), #(data[7] << 8) | data[6],
          "strCount"     => data.read_bytes(UInt16, IO::ByteFormat::LittleEndian), #(data[9] << 8) | data[8],
          "strTableSize" => data.read_bytes(UInt16, IO::ByteFormat::LittleEndian), #(data[11] << 8) | data[10]
        }
        h["total"] =
          h["headerSize"] +
          h["namesSize"] +
          h["boolCount"] +
          h["numCount"] * 2 +
          h["strCount"] * 2 +
          h["strTableSize"]

        p h

        # Names Section
        names = data.read_string h["namesSize"] # XXX how much does this read
        parts= names.split '|'
        name = parts[0]
        desc = parts.pop()

        # Names is nul-terminated, check for it.
        raise "Names must be nul-terminated" unless names[-1].ord==0

        # Booleans Section
        # One byte for each flag
        # Same order as <term.h>
        bools = Hash(String,Bool)
        h["boolCount"].times do |i|
          v = Bools[i]
          #puts "#{v} = #{data.read_bytes(UInt8, IO::ByteFormat::LittleEndian) == 1}"
        end

        # Numbers Section
        h["numCount"].times do |i|
          v = Numbers[i]
          n = data.read_bytes(UInt16, IO::ByteFormat::LittleEndian)
          n=-1 if n == 65535
          #puts "#{v} = #{n}"
        end

        # Strings section
        h["strCount"].times do |i|
          v = Strings[i]
          n = data.read_bytes(UInt16, IO::ByteFormat::LittleEndian)
          # Workaround: fix an odd bug in the screen-256color terminfo where it tries
          # to set -1, but it appears to have {0xfe, 0xff} (65534) instead of {0xff, 0xff} (65535).
          if n>0 && n<65534
            data.seek -2, ::IO::Seek::Current
            n = data.read_string(2)
            puts "#{v} = #{n}"
          end
        end

        # Extended header
        if @extended
          # TODO
        end

        # TODO reject string keys with value >= 65534

      # Parsing seems correct up to here

       return

#      #// Extended Header
#      if (@extended)
#        i= data.pos= start+ h.strTableSize
#        # nil byte in between to make sure numbers begin on an even byte.
#        if (i % 2 != 0)
#          c= data.read_byte # This is padding, should contain nul-character
#          raise "Padding must be a nul-character" unless c==0
#          i+= 1
#        end
#
#        if i< data.size-1
#          begin
#            extended= parseExtended(data)
#          rescue e : Exception
#            if (@debug)
#              raise e;
#            end
#            return info;
#          end
#          #info["header"]["extended"] = extended["header"];
#          #info["bools"].merge extended["bools"]
#          #info["numbers"].merge extended["numbers"]
#          #info["strings"].merge extended["strings"]
#        end
#    end

    end

    #return info
  end

  def compile_terminfo(term)
    compile read_terminfo term
  end

  def compile(arg)
  end
  def inject(arg)
  end

  end
end

