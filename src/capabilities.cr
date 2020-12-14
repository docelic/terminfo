class Terminfo
  # Mappings between symbolic, terminfo, and termcap names, and corresponding indices. Taken from terminfo(5) man page.
  class Capabilities

    getter booleans
    getter numbers
    getter strings

    def initialize
      @booleans = Booleans.new
      @numbers = Numbers.new
      @strings = Strings.new
    end

    module Macros
      # Creates all getters based on table with data.
      #
      # Each table entry is expected to have the following values:
      #   [ ConstantName, long_name, shortnames... ]
      #
      # From this, the macro:
      # 1. Creates all ConstantNames as constants
      # 2. Creates all long_names as getters and class_getters (getters disabled for now)
      # 3. Creates and populates indices Hash
      # 4. Creates and populates List Array
      # 5. Defines [] and []? as instance and methods which map all names to indices (instance methods and []? disabled for now)
      # 6. Checks that termcap and terminfo short name aren't conflicting
      private macro create_all_from(table)
        # Will map  name=>idx
        {% indices = {} of String => Int32 %}
        # Will keep list of  name
        {% list = [] of String %}
        {% for e, idx in table.resolve %}
          #{{e[0].id}} = {{idx}} # Creates the constant
          {% list << e[1] %}
          #class_getter {{e[1].id}} = {{idx}}
          #getter {{e[1].id}} = {{idx}}
          {% for n, idx2 in e %}
            {% if (idx2==1) && (indices[n]) && (e[1]!=e[2]) %}
              print "Short name #{{{n}}} already defined!"
            {% end %}
            {% indices[n] = idx %}
          {% end %}
        {% end %}
        getter indices = {{indices}}
        getter list = {{list}}

        def [](cap) indices[cap] end
        #def self.[](cap) indices[cap] end

        # These are disabled for now; can't think of a case where
        # one would want to retrieve a non-existing capability.
        #def self.[]?(cap) indices[cap]? end
        #def []?(cap) indices[cap]? end
      end
    end

    # Boolean terminfo capabilities
    class Booleans
      include Macros

      Table = [
        [ "AutoLeftMargin"             , "auto_left_margin"           , "bw",    "bw"], #  cub1 wraps from col‐ umn 0 to last column
        [ "AutoRightMargin"            , "auto_right_margin"          , "am",    "am"], #  terminal has auto‐ matic margins
        [ "NoEscCtlc"                  , "no_esc_ctlc"                , "xsb",   "xb", "beehive_glitch"], #  beehive (f1=escape, f2=ctrl C)
        [ "CeolStandoutGlitch"         , "ceol_standout_glitch"       , "xhp",   "xs"], #  standout not erased by overwriting (hp)
        [ "EatNewlineGlitch"           , "eat_newline_glitch"         , "xenl",  "xn"], #  newline ignored after 80 cols (con‐ cept)
        [ "EraseOverstrike"            , "erase_overstrike"           , "eo",    "eo"], #  can erase over‐ strikes with a blank
        [ "GenericType"                , "generic_type"               , "gn",    "gn"], #  generic line type
        [ "HardCopy"                   , "hard_copy"                  , "hc",    "hc"], #  hardcopy terminal
        [ "HasMetaKey"                 , "has_meta_key"               , "km",    "km"], #  Has a meta key (i.e., sets 8th-bit)
        [ "HasStatusLine"              , "has_status_line"            , "hs",    "hs"], #  has extra status line
        [ "InsertNullGlitch"           , "insert_null_glitch"         , "in",    "in"], #  insert mode distin‐ guishes nulls
        [ "MemoryAbove"                , "memory_above"               , "da",    "da"], #  display may be retained above the screen
        [ "MemoryBelow"                , "memory_below"               , "db",    "db"], #  display may be retained below the screen
        [ "MoveInsertMode"             , "move_insert_mode"           , "mir",   "mi"], #  safe to move while in insert mode
        [ "MoveStandoutMode"           , "move_standout_mode"         , "msgr",  "ms"], #  safe to move while in standout mode
        [ "OverStrike"                 , "over_strike"                , "os",    "os"], #  terminal can over‐ strike
        [ "StatusLineEscOk"            , "status_line_esc_ok"         , "eslok", "es"], #  escape can be used on the status line
        [ "DestTabsMagicSmso"          , "dest_tabs_magic_smso"       , "xt",    "xt", "teleray_glitch"], #  tabs destructive, magic so char (t1061)
        [ "TildeGlitch"                , "tilde_glitch"               , "hz",    "hz"], #  cannot print ~'s (hazeltine)
        [ "TransparentUnderline"       , "transparent_underline"      , "ul",    "ul"], #  underline character overstrikes
        [ "XonXoff"                    , "xon_xoff"                   , "xon",   "xo"], #  terminal uses xon/xoff handshaking
        [ "NeedsXonXoff"               , "needs_xon_xoff"             , "nxon",  "nx"], #  padding will not work, xon/xoff required
        [ "PrtrSilent"                 , "prtr_silent"                , "mc5i",  "5i"], #  printer will not echo on screen
        [ "HardCursor"                 , "hard_cursor"                , "chts",  "HC"], #  cursor is hard to see
        [ "NonRevRmcup"                , "non_rev_rmcup"              , "nrrmc", "NR"], #  smcup does not reverse rmcup
        [ "NoPadChar"                  , "no_pad_char"                , "npc",   "NP"], #  pad character does not exist
        [ "NonDestScrollRegion"        , "non_dest_scroll_region"     , "ndscr", "ND"], #  scrolling region is non-destructive
        [ "CanChange"                  , "can_change"                 , "ccc",   "cc"], #  terminal can re- define existing col‐ ors
        [ "BackColorErase"             , "back_color_erase"           , "bce",   "ut"], #  screen erased with background color
        [ "HueLightnessSaturation"     , "hue_lightness_saturation"   , "hls",   "hl"], #  terminal uses only HLS color notation (Tektronix)
        [ "ColAddrGlitch"              , "col_addr_glitch"            , "xhpa",  "YA"], #  only positive motion for hpa/mhpa caps
        [ "CrCancelsMicroMode"         , "cr_cancels_micro_mode"      , "crxm",  "YB"], #  using cr turns off micro mode
        [ "HasPrintWheel"              , "has_print_wheel"            , "daisy", "YC"], #  printer needs opera‐ tor to change char‐ acter set
        [ "RowAddrGlitch"              , "row_addr_glitch"            , "xvpa",  "YD"], #  only positive motion for vpa/mvpa caps
        [ "SemiAutoRightMargin"        , "semi_auto_right_margin"     , "sam",   "YE"], #  printing in last column causes cr
        [ "CpiChangesRes"              , "cpi_changes_res"            , "cpix",  "YF"], #  changing character pitch changes reso‐ lution
        [ "LpiChangesRes"              , "lpi_changes_res"            , "lpix",  "YG"], #  changing line pitch changes resolution
        [ "BackspacesWithBs"           , "backspaces_with_bs"         , "OTbs"], #  
        [ "CrtNoScrolling"             , "crt_no_scrolling"           , "OTns"], #  
        [ "NoCorrectlyWorkingCr"       , "no_correctly_working_cr"    , "OTnc"], #  
        [ "GnuHasMetaKey"              , "gnu_has_meta_key"           , "OTMT"], #  
        [ "LinefeedIsNewline"          , "linefeed_is_newline"        , "OTNL"], #  
        [ "HasHardwareTabs"            , "has_hardware_tabs"          , "OTpt"], #  
        [ "ReturnDoesClrEol"           , "return_does_clr_eol"        , "OTxr"], #  
      ]

      create_all_from Table
    end

    # Numeric terminfo capabilities
    class Numbers
      include Macros

      Table = [
        [ "Columns",                     "columns"                   , "cols",  "co"], #  number of columns in a line
        [ "InitTabs",                    "init_tabs"                 , "it",    "it"], #  tabs initially every # spaces
        [ "Lines",                       "lines"                     , "lines", "li"], #  number of lines on screen or page
        [ "LinesOfMemory",               "lines_of_memory"           , "lm",    "lm"], #  lines of memory if > line. 0 means varies
        [ "MagicCookieGlitch",           "magic_cookie_glitch"       , "xmc",   "sg"], #  number of blank characters left by smso or rmso
        [ "PaddingBaudRate",             "padding_baud_rate"         , "pb",    "pb"], #  lowest baud rate where padding needed
        [ "VirtualTerminal",             "virtual_terminal"          , "vt",    "vt"], #  virtual terminal number (CB/unix)
        [ "WidthStatusLine",             "width_status_line"         , "wsl",   "ws"], #  number of columns in status line
        [ "NumLabels",                   "num_labels"                , "nlab",  "Nl"], #  number of labels on screen
        [ "LabelHeight",                 "label_height"              , "lh",    "lh"], #  rows in each label
        [ "LabelWidth",                  "label_width"               , "lw",    "lw"], #  columns in each label
        [ "MaxAttributes",               "max_attributes"            , "ma",    "ma"], #  maximum combined attributes terminal can handle
        [ "MaximumWindows",              "maximum_windows"           , "wnum",  "MW"], #  maximum number of defineable windows
        [ "MaxColors",                   "max_colors"                , "colors","Co"], #  maximum number of colors on screen
        [ "MaxPairs",                    "max_pairs"                 , "pairs", "pa"], #  maximum number of color-pairs on the screen
        [ "NoColorVideo",                "no_color_video"            , "ncv",   "NC"], #  video attributes that cannot be used with colors
        [ "BufferCapacity",              "buffer_capacity"           , "bufsz", "Ya"], #  numbers of bytes buffered before printing
        [ "DotVertSpacing",              "dot_vert_spacing"          , "spinv", "Yb"], #  spacing of pins ver‐ tically in pins per inch
        [ "DotHorzSpacing",              "dot_horz_spacing"          , "spinh", "Yc"], #  spacing of dots hor‐ izontally in dots per inch
        [ "MaxMicroAddress",             "max_micro_address"         , "maddr", "Yd"], #  maximum value in micro_..._address
        [ "MaxMicroJump",                "max_micro_jump"            , "mjump", "Ye"], #  maximum value in parm_..._micro
        [ "MicroColSize",                "micro_col_size"            , "mcs",   "Yf", "micro_char_size"], #  character step size when in micro mode
        [ "MicroLineSize",               "micro_line_size"           , "mls",   "Yg"], #  line step size when in micro mode
        [ "NumberOfPins",                "number_of_pins"            , "npins", "Yh"], #  numbers of pins in print-head
        [ "OutputResChar",               "output_res_char"           , "orc",   "Yi"], #  horizontal resolu‐ tion in units per line
        [ "OutputResLine",               "output_res_line"           , "orl",   "Yj"], #  vertical resolution in units per line
        [ "OutputResHorzInch",           "output_res_horz_inch"      , "orhi",  "Yk"], #  horizontal resolu‐ tion in units per inch
        [ "OutputResVertInch",           "output_res_vert_inch"      , "orvi",  "Yl"], #  vertical resolution in units per inch
        [ "PrintRate",                   "print_rate"                , "cps",   "Ym"], #  print rate in char‐ acters per second
        [ "WideCharSize",                "wide_char_size"            , "widcs", "Yn"], #  character step size when in double wide mode
        [ "Buttons",                     "buttons"                   , "btns",  "BT"], #  number of buttons on mouse
        [ "BitImageEntwining",           "bit_image_entwining"       , "bitwin","Yo"], #  number of passes for each bit-image row
        [ "BitImageType",                "bit_image_type"            , "bitype","Yp"], #  type of bit-image device
        [ "MagicCookieGlitchUl",         "magic_cookie_glitch_ul"    , "UTug"], #  
        [ "CarriageReturnDelay",         "carriage_return_delay"     , "OTdC"], #  
        [ "NewLineDelay",                "new_line_delay"            , "OTdN"], #  
        [ "BackspaceDelay",              "backspace_delay"           , "OTdB"], #  
        [ "HorizontalTabDelay",          "horizontal_tab_delay"      , "OTdT"], #  
        [ "NumberOfFunctionKeys",        "number_of_function_keys"   , "OTkn"], #  
      ]

      create_all_from Table
    end

    # String terminfo capabilities
    class Strings
      include Macros

      Table = [
        [ "BackTab",                     "back_tab"                  , "cbt",   "bt"], #  back tab (P)
        [ "Bell",                        "bell"                      , "bel",   "bl"], #  audible signal (bell) (P)
        [ "CarriageReturn",              "carriage_return"           , "cr",    "cr"], #  carriage return (P*) (P*)
        [ "ChangeScrollRegion",          "change_scroll_region"      , "csr",   "cs"], #  change region to line #1 to line #2 (P)
        [ "ClearAllTabs",                "clear_all_tabs"            , "tbc",   "ct"], #  clear all tab stops (P)
        [ "ClearScreen",                 "clear_screen"              , "clear", "cl"], #  clear screen and home cursor (P*)
        [ "ClrEol",                      "clr_eol"                   , "el",    "ce"], #  clear to end of line (P)
        [ "ClrEos",                      "clr_eos"                   , "ed",    "cd"], #  clear to end of screen (P*)
        [ "ColumnAddress",               "column_address"            , "hpa",   "ch"], #  horizontal position #1, absolute (P)
        [ "CommandCharacter",            "command_character"         , "cmdch", "CC"], #  terminal settable cmd character in prototype !?
        [ "CursorAddress",               "cursor_address"            , "cup",   "cm", "cursor_position", "cursor_pos"], #  move to row #1 col‐ umns #2
        [ "CursorDown",                  "cursor_down"               , "cud1",  "do"], #  down one line
        [ "CursorHome",                  "cursor_home"               , "home",  "ho"], #  home cursor (if no cup)
        [ "CursorInvisible",             "cursor_invisible"          , "civis", "vi"], #  make cursor invisi‐ ble
        [ "CursorLeft",                  "cursor_left"               , "cub1",  "le"], #  move left one space
        [ "CursorMemAddress",            "cursor_mem_address"        , "mrcup", "CM"], #  memory relative cur‐ sor addressing, move to row #1 columns #2
        [ "CursorNormal",                "cursor_normal"             , "cnorm", "ve"], #  make cursor appear normal (undo civis/cvvis)
        [ "CursorRight",                 "cursor_right"              , "cuf1",  "nd"], #  non-destructive space (move right one space)
        [ "CursorToLl",                  "cursor_to_ll"              , "ll",    "ll"], #  last line, first column (if no cup)
        [ "CursorUp",                    "cursor_up"                 , "cuu1",  "up"], #  up one line
        [ "CursorVisible",               "cursor_visible"            , "cvvis", "vs"], #  make cursor very visible
        [ "DeleteCharacter",             "delete_character"          , "dch1",  "dc"], #  delete character (P*)
        [ "DeleteLine",                  "delete_line"               , "dl1"], #  "dl"], #  delete line (P*)  <-- termcap name already exists; disabled
        [ "DisStatusLine",               "dis_status_line"           , "dsl",   "ds"], #  disable status line
        [ "DownHalfLine",                "down_half_line"            , "hd",    "hd"], #  half a line down
        [ "EnterAltCharsetMode",         "enter_alt_charset_mode"    , "smacs", "as"], #  start alternate character set (P)
        [ "EnterBlinkMode",              "enter_blink_mode"          , "blink", "mb"], #  turn on blinking
        [ "EnterBoldMode",               "enter_bold_mode"           , "bold",  "md"], #  turn on bold (extra bright) mode
        [ "EnterCaMode",                 "enter_ca_mode"             , "smcup", "ti"], #  string to start pro‐ grams using cup
        [ "EnterDeleteMode",             "enter_delete_mode"         , "smdc",  "dm"], #  enter delete mode
        [ "EnterDimMode",                "enter_dim_mode"            , "dim",   "mh"], #  turn on half-bright mode
        [ "EnterInsertMode",             "enter_insert_mode"         , "smir",  "im"], #  enter insert mode
        [ "EnterSecureMode",             "enter_secure_mode"         , "invis", "mk"], #  turn on blank mode (characters invisi‐ ble)
        [ "EnterProtectedMode",          "enter_protected_mode"      , "prot",  "mp"], #  turn on protected mode
        [ "EnterReverseMode",            "enter_reverse_mode"        , "rev",   "mr"], #  turn on reverse video mode
        [ "EnterStandoutMode",           "enter_standout_mode"       , "smso",  "so"], #  begin standout mode
        [ "EnterUnderlineMode",          "enter_underline_mode"      , "smul",  "us"], #  begin underline mode
        [ "EraseChars",                  "erase_chars"               , "ech",   "ec"], #  erase #1 characters (P)
        [ "ExitAltCharsetMode",          "exit_alt_charset_mode"     , "rmacs", "ae"], #  end alternate char‐ acter set (P)
        [ "ExitAttributeMode",           "exit_attribute_mode"       , "sgr0",  "me"], #  turn off all attributes
        [ "ExitCaMode",                  "exit_ca_mode"              , "rmcup", "te"], #  strings to end pro‐ grams using cup
        [ "ExitDeleteMode",              "exit_delete_mode"          , "rmdc",  "ed"], #  end delete mode
        [ "ExitInsertMode",              "exit_insert_mode"          , "rmir",  "ei"], #  exit insert mode
        [ "ExitStandoutMode",            "exit_standout_mode"        , "rmso",  "se"], #  exit standout mode
        [ "ExitUnderlineMode",           "exit_underline_mode"       , "rmul",  "ue"], #  exit underline mode
        [ "FlashScreen",                 "flash_screen"              , "flash", "vb"], #  visible bell (may not move cursor)
        [ "FormFeed",                    "form_feed"                 , "ff",    "ff"], #  hardcopy terminal page eject (P*)
        [ "FromStatusLine",              "from_status_line"          , "fsl",   "fs"], #  return from status line
        [ "Init1string",                 "init_1string"              , "is1",   "i1"], #  initialization string
        [ "Init2string",                 "init_2string"              , "is2",   "is"], #  initialization string
        [ "Init3string",                 "init_3string"              , "is3",   "i3"], #  initialization string
        [ "InitFile",                    "init_file"                 , "if",    "if"], #  name of initializa‐ tion file
        [ "InsertCharacter",             "insert_character"          , "ich1",  "ic"], #  insert character (P)
        [ "InsertLine",                  "insert_line"               , "il1",   "al"], #  insert line (P*)
        [ "InsertPadding",               "insert_padding"            , "ip",    "ip"], #  insert padding after inserted character
        [ "KeyBackspace",                "key_backspace"             , "kbs",   "kb"], #  backspace key
        [ "KeyCatab",                    "key_catab"                 , "ktbc",  "ka"], #  clear-all-tabs key
        [ "KeyClear",                    "key_clear"                 , "kclr",  "kC"], #  clear-screen or erase key
        [ "KeyCtab",                     "key_ctab"                  , "kctab", "kt"], #  clear-tab key
        [ "KeyDc",                       "key_dc"                    , "kdch1", "kD"], #  delete-character key
        [ "KeyDl",                       "key_dl"                    , "kdl1",  "kL"], #  delete-line key
        [ "KeyDown",                     "key_down"                  , "kcud1", "kd"], #  down-arrow key
        [ "KeyEic",                      "key_eic"                   , "krmir", "kM"], #  sent by rmir or smir in insert mode
        [ "KeyEol",                      "key_eol"                   , "kel",   "kE"], #  clear-to-end-of-line key
        [ "KeyEos",                      "key_eos"                   , "ked",   "kS"], #  clear-to-end-of- screen key
        [ "KeyF0",                       "key_f0"                    , "kf0",   "k0"], #  F0 function key
        [ "KeyF1",                       "key_f1"                    , "kf1",   "k1"], #  F1 function key
        [ "KeyF10",                      "key_f10"                   , "kf10",  "k;"], #  F10 function key
        [ "KeyF2",                       "key_f2"                    , "kf2",   "k2"], #  F2 function key
        [ "KeyF3",                       "key_f3"                    , "kf3",   "k3"], #  F3 function key
        [ "KeyF4",                       "key_f4"                    , "kf4",   "k4"], #  F4 function key
        [ "KeyF5",                       "key_f5"                    , "kf5",   "k5"], #  F5 function key
        [ "KeyF6",                       "key_f6"                    , "kf6",   "k6"], #  F6 function key
        [ "KeyF7",                       "key_f7"                    , "kf7",   "k7"], #  F7 function key
        [ "KeyF8",                       "key_f8"                    , "kf8",   "k8"], #  F8 function key
        [ "KeyF9",                       "key_f9"                    , "kf9",   "k9"], #  F9 function key
        [ "KeyHome",                     "key_home"                  , "khome", "kh"], #  home key
        [ "KeyIc",                       "key_ic"                    , "kich1", "kI"], #  insert-character key
        [ "KeyIl",                       "key_il"                    , "kil1",  "kA"], #  insert-line key
        [ "KeyLeft",                     "key_left"                  , "kcub1", "kl"], #  left-arrow key
        [ "KeyLl",                       "key_ll"                    , "kll",   "kH"], #  lower-left key (home down)
        [ "KeyNpage",                    "key_npage"                 , "knp",   "kN"], #  next-page key
        [ "KeyPpage",                    "key_ppage"                 , "kpp",   "kP"], #  previous-page key
        [ "KeyRight",                    "key_right"                 , "kcuf1", "kr"], #  right-arrow key
        [ "KeySf",                       "key_sf"                    , "kind",  "kF"], #  scroll-forward key
        [ "KeySr",                       "key_sr"                    , "kri",   "kR"], #  scroll-backward key
        [ "KeyStab",                     "key_stab"                  , "khts",  "kT"], #  set-tab key
        [ "KeyUp",                       "key_up"                    , "kcuu1", "ku"], #  up-arrow key
        [ "KeypadLocal",                 "keypad_local"              , "rmkx",  "ke"], #  leave "key‐ board_transmit" mode
        [ "KeypadXmit",                  "keypad_xmit"               , "smkx",  "ks"], #  enter "key‐ board_transmit" mode
        [ "LabF0",                       "lab_f0"                    , "lf0",   "l0"], #  label on function key f0 if not f0
        [ "LabF1",                       "lab_f1"                    , "lf1",   "l1"], #  label on function key f1 if not f1
        [ "LabF10",                      "lab_f10"                   , "lf10",  "la"], #  label on function key f10 if not f10
        [ "LabF2",                       "lab_f2"                    , "lf2",   "l2"], #  label on function key f2 if not f2
        [ "LabF3",                       "lab_f3"                    , "lf3",   "l3"], #  label on function key f3 if not f3
        [ "LabF4",                       "lab_f4"                    , "lf4",   "l4"], #  label on function key f4 if not f4
        [ "LabF5",                       "lab_f5"                    , "lf5",   "l5"], #  label on function key f5 if not f5
        [ "LabF6",                       "lab_f6"                    , "lf6",   "l6"], #  label on function key f6 if not f6
        [ "LabF7",                       "lab_f7"                    , "lf7",   "l7"], #  label on function key f7 if not f7
        [ "LabF8",                       "lab_f8"                    , "lf8",   "l8"], #  label on function key f8 if not f8
        [ "LabF9",                       "lab_f9"                    , "lf9",   "l9"], #  label on function key f9 if not f9
        [ "MetaOff",                     "meta_off"                  , "rmm",   "mo"], #  turn off meta mode
        [ "MetaOn",                      "meta_on"                   , "smm",   "mm"], #  turn on meta mode (8th-bit on)
        [ "Newline",                     "newline"                   , "nel",   "nw"], #  newline (behave like cr followed by lf)
        [ "PadChar",                     "pad_char"                  , "pad",   "pc"], #  padding char (instead of null)
        [ "ParmDch",                     "parm_dch"                  , "dch",   "DC"], #  delete #1 characters (P*)
        [ "ParmDeleteLine",              "parm_delete_line"          , "dl",    "DL"], #  delete #1 lines (P*)
        [ "ParmDownCursor",              "parm_down_cursor"          , "cud",   "DO"], #  down #1 lines (P*)
        [ "ParmIch",                     "parm_ich"                  , "ich",   "IC"], #  insert #1 characters (P*)
        [ "ParmIndex",                   "parm_index"                , "indn",  "SF"], #  scroll forward #1 lines (P)
        [ "ParmInsertLine",              "parm_insert_line"          , "il",    "AL"], #  insert #1 lines (P*)
        [ "ParmLeftCursor",              "parm_left_cursor"          , "cub",   "LE"], #  move #1 characters to the left (P)
        [ "ParmRightCursor",             "parm_right_cursor"         , "cuf",   "RI"], #  move #1 characters to the right (P*)
        [ "ParmRindex",                  "parm_rindex"               , "rin",   "SR"], #  scroll back #1 lines (P)
        [ "ParmUpCursor",                "parm_up_cursor"            , "cuu",   "UP"], #  up #1 lines (P*)
        [ "PkeyKey",                     "pkey_key"                  , "pfkey", "pk"], #  program function key #1 to type string #2
        [ "PkeyLocal",                   "pkey_local"                , "pfloc", "pl"], #  program function key #1 to execute string #2
        [ "PkeyXmit",                    "pkey_xmit"                 , "pfx",   "px"], #  program function key #1 to transmit string #2
        [ "PrintScreen",                 "print_screen"              , "mc0",   "ps"], #  print contents of screen
        [ "PrtrOff",                     "prtr_off"                  , "mc4",   "pf"], #  turn off printer
        [ "PrtrOn",                      "prtr_on"                   , "mc5",   "po"], #  turn on printer
        [ "RepeatChar",                  "repeat_char"               , "rep",   "rp"], #  repeat char #1 #2 times (P*)
        [ "Reset1string",                "reset_1string"             , "rs1",   "r1"], #  reset string
        [ "Reset2string",                "reset_2string"             , "rs2",   "r2"], #  reset string
        [ "Reset3string",                "reset_3string"             , "rs3",   "r3"], #  reset string
        [ "ResetFile",                   "reset_file"                , "rf",    "rf"], #  name of reset file
        [ "RestoreCursor",               "restore_cursor"            , "rc",    "rc"], #  restore cursor to position of last save_cursor
        [ "RowAddress",                  "row_address"               , "vpa",   "cv"], #  vertical position #1 absolute (P)
        [ "SaveCursor",                  "save_cursor"               , "sc",    "sc"], #  save current cursor position (P)
        [ "ScrollForward",               "scroll_forward"            , "ind",   "sf"], #  scroll text up (P)
        [ "ScrollReverse",               "scroll_reverse"            , "ri",    "sr"], #  scroll text down (P)
        [ "SetAttributes",               "set_attributes"            , "sgr",   "sa"], #  define video attributes #1-#9 (PG9)
        [ "SetTab",                      "set_tab"                   , "hts",   "st"], #  set a tab in every row, current columns
        [ "SetWindow",                   "set_window"                , "wind",  "wi"], #  current window is lines #1-#2 cols #3-#4
        [ "Tab",                         "tab"                       , "ht",    "ta"], #  tab to next 8-space hard‐ ware tab stop
        [ "ToStatusLine",                "to_status_line"            , "tsl",   "ts"], #  move to status line, col‐ umn #1
        [ "UnderlineChar",               "underline_char"            , "uc",    "uc"], #  underline char and move past it
        [ "UpHalfLine",                  "up_half_line"              , "hu",    "hu"], #  half a line up
        [ "InitProg",                    "init_prog"                 , "iprog", "iP"], #  path name of program for initialization
        [ "KeyA1",                       "key_a1"                    , "ka1",   "K1"], #  upper left of keypad
        [ "KeyA3",                       "key_a3"                    , "ka3",   "K3"], #  upper right of key‐ pad
        [ "KeyB2",                       "key_b2"                    , "kb2",   "K2"], #  center of keypad
        [ "KeyC1",                       "key_c1"                    , "kc1",   "K4"], #  lower left of keypad
        [ "KeyC3",                       "key_c3"                    , "kc3",   "K5"], #  lower right of key‐ pad
        [ "PrtrNon",                     "prtr_non"                  , "mc5p",  "pO"], #  turn on printer for #1 bytes
        [ "CharPadding",                 "char_padding"              , "rmp",   "rP"], #  like ip but when in insert mode
        [ "AcsChars",                    "acs_chars"                 , "acsc",  "ac"], #  graphics charset pairs, based on vt100
        [ "PlabNorm",                    "plab_norm"                 , "pln",   "pn"], #  program label #1 to show string #2
        [ "KeyBtab",                     "key_btab"                  , "kcbt",  "kB"], #  back-tab key
        [ "EnterXonMode",                "enter_xon_mode"            , "smxon", "SX"], #  turn on xon/xoff handshaking
        [ "ExitXonMode",                 "exit_xon_mode"             , "rmxon", "RX"], #  turn off xon/xoff handshaking
        [ "EnterAmMode",                 "enter_am_mode"             , "smam",  "SA"], #  turn on automatic margins
        [ "ExitAmMode",                  "exit_am_mode"              , "rmam",  "RA"], #  turn off automatic margins
        [ "XonCharacter",                "xon_character"             , "xonc",  "XN"], #  XON character
        [ "XoffCharacter",               "xoff_character"            , "xoffc", "XF"], #  XOFF character
        [ "EnaAcs",                      "ena_acs"                   , "enacs", "eA"], #  enable alternate char set
        [ "LabelOn",                     "label_on"                  , "smln",  "LO"], #  turn on soft labels
        [ "LabelOff",                    "label_off"                 , "rmln",  "LF"], #  turn off soft labels
        [ "KeyBeg",                      "key_beg"                   , "kbeg",  "@1"], #  begin key
        [ "KeyCancel",                   "key_cancel"                , "kcan",  "@2"], #  cancel key
        [ "KeyClose",                    "key_close"                 , "kclo",  "@3"], #  close key
        [ "KeyCommand",                  "key_command"               , "kcmd",  "@4"], #  command key
        [ "KeyCopy",                     "key_copy"                  , "kcpy",  "@5"], #  copy key
        [ "KeyCreate",                   "key_create"                , "kcrt",  "@6"], #  create key
        [ "KeyEnd",                      "key_end"                   , "kend",  "@7"], #  end key
        [ "KeyEnter",                    "key_enter"                 , "kent",  "@8"], #  enter/send key
        [ "KeyExit",                     "key_exit"                  , "kext",  "@9"], #  exit key
        [ "KeyFind",                     "key_find"                  , "kfnd",  "@0"], #  find key
        [ "KeyHelp",                     "key_help"                  , "khlp",  "%1"], #  help key
        [ "KeyMark",                     "key_mark"                  , "kmrk",  "%2"], #  mark key
        [ "KeyMessage",                  "key_message"               , "kmsg",  "%3"], #  message key
        [ "KeyMove",                     "key_move"                  , "kmov",  "%4"], #  move key
        [ "KeyNext",                     "key_next"                  , "knxt",  "%5"], #  next key
        [ "KeyOpen",                     "key_open"                  , "kopn",  "%6"], #  open key
        [ "KeyOptions",                  "key_options"               , "kopt",  "%7"], #  options key
        [ "KeyPrevious",                 "key_previous"              , "kprv",  "%8"], #  previous key
        [ "KeyPrint",                    "key_print"                 , "kprt",  "%9"], #  print key
        [ "KeyRedo",                     "key_redo"                  , "krdo",  "%0"], #  redo key
        [ "KeyReference",                "key_reference"             , "kref",  "&1"], #  reference key
        [ "KeyRefresh",                  "key_refresh"               , "krfr",  "&2"], #  refresh key
        [ "KeyReplace",                  "key_replace"               , "krpl",  "&3"], #  replace key
        [ "KeyRestart",                  "key_restart"               , "krst",  "&4"], #  restart key
        [ "KeyResume",                   "key_resume"                , "kres",  "&5"], #  resume key
        [ "KeySave",                     "key_save"                  , "ksav",  "&6"], #  save key
        [ "KeySuspend",                  "key_suspend"               , "kspd",  "&7"], #  suspend key
        [ "KeyUndo",                     "key_undo"                  , "kund",  "&8"], #  undo key
        [ "KeySbeg",                     "key_sbeg"                  , "kBEG",  "&9"], #  shifted begin key
        [ "KeyScancel",                  "key_scancel"               , "kCAN",  "&0"], #  shifted cancel key
        [ "KeyScommand",                 "key_scommand"              , "kCMD",  "*1"], #  shifted command key
        [ "KeyScopy",                    "key_scopy"                 , "kCPY",  "*2"], #  shifted copy key
        [ "KeyScreate",                  "key_screate"               , "kCRT",  "*3"], #  shifted create key
        [ "KeySdc",                      "key_sdc"                   , "kDC",   "*4"], #  shifted delete-char‐ acter key
        [ "KeySdl",                      "key_sdl"                   , "kDL",   "*5"], #  shifted delete-line key
        [ "KeySelect",                   "key_select"                , "kslt",  "*6"], #  select key
        [ "KeySend",                     "key_send"                  , "kEND",  "*7"], #  shifted end key
        [ "KeySeol",                     "key_seol"                  , "kEOL",  "*8"], #  shifted clear-to- end-of-line key
        [ "KeySexit",                    "key_sexit"                 , "kEXT",  "*9"], #  shifted exit key
        [ "KeySfind",                    "key_sfind"                 , "kFND",  "*0"], #  shifted find key
        [ "KeyShelp",                    "key_shelp"                 , "kHLP",  "#1"], #  shifted help key
        [ "KeyShome",                    "key_shome"                 , "kHOM",  "#2"], #  shifted home key
        [ "KeySic",                      "key_sic"                   , "kIC",   "#3"], #  shifted insert-char‐ acter key
        [ "KeySleft",                    "key_sleft"                 , "kLFT",  "#4"], #  shifted left-arrow key
        [ "KeySmessage",                 "key_smessage"              , "kMSG",  "%a"], #  shifted message key
        [ "KeySmove",                    "key_smove"                 , "kMOV",  "%b"], #  shifted move key
        [ "KeySnext",                    "key_snext"                 , "kNXT",  "%c"], #  shifted next key
        [ "KeySoptions",                 "key_soptions"              , "kOPT",  "%d"], #  shifted options key
        [ "KeySprevious",                "key_sprevious"             , "kPRV",  "%e"], #  shifted previous key
        [ "KeySprint",                   "key_sprint"                , "kPRT",  "%f"], #  shifted print key
        [ "KeySredo",                    "key_sredo"                 , "kRDO",  "%g"], #  shifted redo key
        [ "KeySreplace",                 "key_sreplace"              , "kRPL",  "%h"], #  shifted replace key
        [ "KeySright",                   "key_sright"                , "kRIT",  "%i"], #  shifted right-arrow key
        [ "KeySrsume",                   "key_srsume"                , "kRES",  "%j"], #  shifted resume key
        [ "KeySsave",                    "key_ssave"                 , "kSAV",  "!1"], #  shifted save key
        [ "KeySsuspend",                 "key_ssuspend"              , "kSPD",  "!2"], #  shifted suspend key
        [ "KeySundo",                    "key_sundo"                 , "kUND",  "!3"], #  shifted undo key
        [ "ReqForInput",                 "req_for_input"             , "rfi",   "RF"], #  send next input char (for ptys)
        [ "KeyF11",                      "key_f11"                   , "kf11",  "F1"], #  F11 function key
        [ "KeyF12",                      "key_f12"                   , "kf12",  "F2"], #  F12 function key
        [ "KeyF13",                      "key_f13"                   , "kf13",  "F3"], #  F13 function key
        [ "KeyF14",                      "key_f14"                   , "kf14",  "F4"], #  F14 function key
        [ "KeyF15",                      "key_f15"                   , "kf15",  "F5"], #  F15 function key
        [ "KeyF16",                      "key_f16"                   , "kf16",  "F6"], #  F16 function key
        [ "KeyF17",                      "key_f17"                   , "kf17",  "F7"], #  F17 function key
        [ "KeyF18",                      "key_f18"                   , "kf18",  "F8"], #  F18 function key
        [ "KeyF19",                      "key_f19"                   , "kf19",  "F9"], #  F19 function key
        [ "KeyF20",                      "key_f20"                   , "kf20",  "FA"], #  F20 function key
        [ "KeyF21",                      "key_f21"                   , "kf21",  "FB"], #  F21 function key
        [ "KeyF22",                      "key_f22"                   , "kf22",  "FC"], #  F22 function key
        [ "KeyF23",                      "key_f23"                   , "kf23",  "FD"], #  F23 function key
        [ "KeyF24",                      "key_f24"                   , "kf24",  "FE"], #  F24 function key
        [ "KeyF25",                      "key_f25"                   , "kf25",  "FF"], #  F25 function key
        [ "KeyF26",                      "key_f26"                   , "kf26",  "FG"], #  F26 function key
        [ "KeyF27",                      "key_f27"                   , "kf27",  "FH"], #  F27 function key
        [ "KeyF28",                      "key_f28"                   , "kf28",  "FI"], #  F28 function key
        [ "KeyF29",                      "key_f29"                   , "kf29",  "FJ"], #  F29 function key
        [ "KeyF30",                      "key_f30"                   , "kf30",  "FK"], #  F30 function key
        [ "KeyF31",                      "key_f31"                   , "kf31",  "FL"], #  F31 function key
        [ "KeyF32",                      "key_f32"                   , "kf32",  "FM"], #  F32 function key
        [ "KeyF33",                      "key_f33"                   , "kf33",  "FN"], #  F33 function key
        [ "KeyF34",                      "key_f34"                   , "kf34",  "FO"], #  F34 function key
        [ "KeyF35",                      "key_f35"                   , "kf35",  "FP"], #  F35 function key
        [ "KeyF36",                      "key_f36"                   , "kf36",  "FQ"], #  F36 function key
        [ "KeyF37",                      "key_f37"                   , "kf37",  "FR"], #  F37 function key
        [ "KeyF38",                      "key_f38"                   , "kf38",  "FS"], #  F38 function key
        [ "KeyF39",                      "key_f39"                   , "kf39",  "FT"], #  F39 function key
        [ "KeyF40",                      "key_f40"                   , "kf40",  "FU"], #  F40 function key
        [ "KeyF41",                      "key_f41"                   , "kf41",  "FV"], #  F41 function key
        [ "KeyF42",                      "key_f42"                   , "kf42",  "FW"], #  F42 function key
        [ "KeyF43",                      "key_f43"                   , "kf43",  "FX"], #  F43 function key
        [ "KeyF44",                      "key_f44"                   , "kf44",  "FY"], #  F44 function key
        [ "KeyF45",                      "key_f45"                   , "kf45",  "FZ"], #  F45 function key
        [ "KeyF46",                      "key_f46"                   , "kf46",  "Fa"], #  F46 function key
        [ "KeyF47",                      "key_f47"                   , "kf47",  "Fb"], #  F47 function key
        [ "KeyF48",                      "key_f48"                   , "kf48",  "Fc"], #  F48 function key
        [ "KeyF49",                      "key_f49"                   , "kf49",  "Fd"], #  F49 function key
        [ "KeyF50",                      "key_f50"                   , "kf50",  "Fe"], #  F50 function key
        [ "KeyF51",                      "key_f51"                   , "kf51",  "Ff"], #  F51 function key
        [ "KeyF52",                      "key_f52"                   , "kf52",  "Fg"], #  F52 function key
        [ "KeyF53",                      "key_f53"                   , "kf53",  "Fh"], #  F53 function key
        [ "KeyF54",                      "key_f54"                   , "kf54",  "Fi"], #  F54 function key
        [ "KeyF55",                      "key_f55"                   , "kf55",  "Fj"], #  F55 function key
        [ "KeyF56",                      "key_f56"                   , "kf56",  "Fk"], #  F56 function key
        [ "KeyF57",                      "key_f57"                   , "kf57",  "Fl"], #  F57 function key
        [ "KeyF58",                      "key_f58"                   , "kf58",  "Fm"], #  F58 function key
        [ "KeyF59",                      "key_f59"                   , "kf59",  "Fn"], #  F59 function key
        [ "KeyF60",                      "key_f60"                   , "kf60",  "Fo"], #  F60 function key
        [ "KeyF61",                      "key_f61"                   , "kf61",  "Fp"], #  F61 function key
        [ "KeyF62",                      "key_f62"                   , "kf62",  "Fq"], #  F62 function key
        [ "KeyF63",                      "key_f63"                   , "kf63",  "Fr"], #  F63 function key
        [ "ClrBol",                      "clr_bol"                   , "el1",   "cb"], #  Clear to beginning of line
        [ "ClearMargins",                "clear_margins"             , "mgc",   "MC"], #  clear right and left soft margins
        [ "SetLeftMargin",               "set_left_margin"           , "smgl",  "ML"], #  set left soft margin at current col‐ umn.  See smgl. (ML is not in BSD termcap).
        [ "SetRightMargin",              "set_right_margin"          , "smgr",  "MR"], #  set right soft margin at current column
        [ "LabelFormat",                 "label_format"              , "fln",   "Lf"], #  label format
        [ "SetClock",                    "set_clock"                 , "sclk",  "SC"], #  set clock, #1 hrs #2 mins #3 secs
        [ "DisplayClock",                "display_clock"             , "dclk",  "DK"], #  display clock
        [ "RemoveClock",                 "remove_clock"              , "rmclk", "RC"], #  remove clock
        [ "CreateWindow",                "create_window"             , "cwin",  "CW"], #  define a window #1 from #2,#3 to #4,#5
        [ "GotoWindow",                  "goto_window"               , "wingo", "WG"], #  go to window #1
        [ "Hangup",                      "hangup"                    , "hup",   "HU"], #  hang-up phone
        [ "DialPhone",                   "dial_phone"                , "dial",  "DI"], #  dial number #1
        [ "QuickDial",                   "quick_dial"                , "qdial", "QD"], #  dial number #1 with‐ out checking
        [ "Tone",                        "tone"                      , "tone",  "TO"], #  select touch tone dialing
        [ "Pulse",                       "pulse"                     , "pulse", "PU"], #  select pulse dialing
        [ "FlashHook",                   "flash_hook"                , "hook",  "fh"], #  flash switch hook
        [ "FixedPause",                  "fixed_pause"               , "pause", "PA"], #  pause for 2-3 sec‐ onds
        [ "WaitTone",                    "wait_tone"                 , "wait",  "WA"], #  wait for dial-tone
        [ "User0",                       "user0"                     , "u0",    "u0"], #  User string #0
        [ "User1",                       "user1"                     , "u1",    "u1"], #  User string #1
        [ "User2",                       "user2"                     , "u2",    "u2"], #  User string #2
        [ "User3",                       "user3"                     , "u3",    "u3"], #  User string #3
        [ "User4",                       "user4"                     , "u4",    "u4"], #  User string #4
        [ "User5",                       "user5"                     , "u5",    "u5"], #  User string #5
        [ "User6",                       "user6"                     , "u6",    "u6"], #  User string #6
        [ "User7",                       "user7"                     , "u7",    "u7"], #  User string #7
        [ "User8",                       "user8"                     , "u8",    "u8"], #  User string #8
        [ "User9",                       "user9"                     , "u9",    "u9"], #  User string #9
        [ "OrigPair",                    "orig_pair"                 , "op",    "op"], #  Set default pair to its original value
        [ "OrigColors",                  "orig_colors"               , "oc",    "oc"], #  Set all color pairs to the original ones
        [ "InitializeColor",             "initialize_color"          , "initc", "Ic"], #  initialize color #1 to (#2,#3,#4)
        [ "InitializePair",              "initialize_pair"           , "initp", "Ip"], #  Initialize color pair #1 to fg=(#2,#3,#4), bg=(#5,#6,#7)
        [ "SetColorPair",                "set_color_pair"            , "scp",   "sp"], #  Set current color pair to #1
        [ "SetForeground",               "set_foreground"            , "setf",  "Sf"], #  Set foreground color #1
        [ "SetBackground",               "set_background"            , "setb",  "Sb"], #  Set background color #1
        [ "ChangeCharPitch",             "change_char_pitch"         , "cpi",   "ZA"], #  Change number of characters per inch to #1
        [ "ChangeLinePitch",             "change_line_pitch"         , "lpi",   "ZB"], #  Change number of lines per inch to #1
        [ "ChangeResHorz",               "change_res_horz"           , "chr",   "ZC"], #  Change horizontal resolution to #1
        [ "ChangeResVert",               "change_res_vert"           , "cvr",   "ZD"], #  Change vertical res‐ olution to #1
        [ "DefineChar",                  "define_char"               , "defc",  "ZE"], #  Define a character #1, #2 dots wide, descender #3
        [ "EnterDoublewideMode",         "enter_doublewide_mode"     , "swidm", "ZF"], #  Enter double-wide mode
        [ "EnterDraftQuality",           "enter_draft_quality"       , "sdrfq", "ZG"], #  Enter draft-quality mode
        [ "EnterItalicsMode",            "enter_italics_mode"        , "sitm",  "ZH"], #  Enter italic mode
        [ "EnterLeftwardMode",           "enter_leftward_mode"       , "slm",   "ZI"], #  Start leftward car‐ riage motion
        [ "EnterMicroMode",              "enter_micro_mode"          , "smicm", "ZJ"], #  Start micro-motion mode
        [ "EnterNearLetterQuality",      "enter_near_letter_quality" , "snlq",  "ZK"], #  Enter NLQ mode
        [ "EnterNormalQuality",          "enter_normal_quality"      , "snrmq", "ZL"], #  Enter normal-quality mode
        [ "EnterShadowMode",             "enter_shadow_mode"         , "sshm",  "ZM"], #  Enter shadow-print mode
        [ "EnterSubscriptMode",          "enter_subscript_mode"      , "ssubm", "ZN"], #  Enter subscript mode
        [ "EnterSuperscriptMode",        "enter_superscript_mode"    , "ssupm", "ZO"], #  Enter superscript mode
        [ "EnterUpwardMode",             "enter_upward_mode"         , "sum",   "ZP"], #  Start upward car‐ riage motion
        [ "ExitDoublewideMode",          "exit_doublewide_mode"      , "rwidm", "ZQ"], #  End double-wide mode
        [ "ExitItalicsMode",             "exit_italics_mode"         , "ritm",  "ZR"], #  End italic mode
        [ "ExitLeftwardMode",            "exit_leftward_mode"        , "rlm",   "ZS"], #  End left-motion mode
        [ "ExitMicroMode",               "exit_micro_mode"           , "rmicm", "ZT"], #  End micro-motion mode
        [ "ExitShadowMode",              "exit_shadow_mode"          , "rshm",  "ZU"], #  End shadow-print mode
        [ "ExitSubscriptMode",           "exit_subscript_mode"       , "rsubm", "ZV"], #  End subscript mode
        [ "ExitSuperscriptMode",         "exit_superscript_mode"     , "rsupm", "ZW"], #  End superscript mode
        [ "ExitUpwardMode",              "exit_upward_mode"          , "rum",   "ZX"], #  End reverse charac‐ ter motion
        [ "MicroColumnAddress",          "micro_column_address"      , "mhpa",  "ZY"], #  Like column_address in micro mode
        [ "MicroDown",                   "micro_down"                , "mcud1", "ZZ"], #  Like cursor_down in micro mode
        [ "MicroLeft",                   "micro_left"                , "mcub1", "Za"], #  Like cursor_left in micro mode
        [ "MicroRight",                  "micro_right"               , "mcuf1", "Zb"], #  Like cursor_right in micro mode
        [ "MicroRowAddress",             "micro_row_address"         , "mvpa",  "Zc"], #  Like row_address #1 in micro mode
        [ "MicroUp",                     "micro_up"                  , "mcuu1", "Zd"], #  Like cursor_up in micro mode
        [ "OrderOfPins",                 "order_of_pins"             , "porder","Ze"], #  Match software bits to print-head pins
        [ "ParmDownMicro",               "parm_down_micro"           , "mcud",  "Zf"], #  Like parm_down_cur‐ sor in micro mode
        [ "ParmLeftMicro",               "parm_left_micro"           , "mcub",  "Zg"], #  Like parm_left_cur‐ sor in micro mode
        [ "ParmRightMicro",              "parm_right_micro"          , "mcuf",  "Zh"], #  Like parm_right_cur‐ sor in micro mode
        [ "ParmUpMicro",                 "parm_up_micro"             , "mcuu",  "Zi"], #  Like parm_up_cursor in micro mode
        [ "SelectCharSet",               "select_char_set"           , "scs",   "Zj"], #  Select character set, #1
        [ "SetBottomMargin",             "set_bottom_margin"         , "smgb",  "Zk"], #  Set bottom margin at current line
        [ "SetBottomMarginParm",         "set_bottom_margin_parm"    , "smgbp", "Zl"], #  Set bottom margin at line #1 or (if smgtp is not given) #2 lines from bottom
        [ "SetLeftMarginParm",           "set_left_margin_parm"      , "smglp", "Zm"], #  Set left (right) margin at column #1
        [ "SetRightMarginParm",          "set_right_margin_parm"     , "smgrp", "Zn"], #  Set right margin at column #1
        [ "SetTopMargin",                "set_top_margin"            , "smgt",  "Zo"], #  Set top margin at current line
        [ "SetTopMarginParm",            "set_top_margin_parm"       , "smgtp", "Zp"], #  Set top (bottom) margin at row #1
        [ "StartBitImage",               "start_bit_image"           , "sbim",  "Zq"], #  Start printing bit image graphics
        [ "StartCharSetDef",             "start_char_set_def"        , "scsd",  "Zr"], #  Start character set defi‐ nition #1, with #2 charac‐ ters in the set
        [ "StopBitImage",                "stop_bit_image"            , "rbim",  "Zs"], #  Stop printing bit image graphics
        [ "StopCharSetDef",              "stop_char_set_def"         , "rcsd",  "Zt"], #  End definition of charac‐ ter set #1
        [ "SubscriptCharacters",         "subscript_characters"      , "subcs", "Zu"], #  List of subscriptable characters
        [ "SuperscriptCharacters",       "superscript_characters"    , "supcs", "Zv"], #  List of superscriptable characters
        [ "TheseCauseCr",                "these_cause_cr"            , "docr",  "Zw"], #  Printing any of these characters causes CR
        [ "ZeroMotion",                  "zero_motion"               , "zerom", "Zx"], #  No motion for subsequent character
        [ "CharSetNames",                "char_set_names"            , "csnm",   "Zy"], # Produce #1"th item from list of char‐ acter set names
        [ "KeyMouse",                    "key_mouse"                 , "kmous",  "Km"], # Mouse event has occurred
        [ "MouseInfo",                   "mouse_info"                , "minfo",  "Mi"], # Mouse status information
        [ "ReqMousePos",                 "req_mouse_pos"             , "reqmp",  "RQ"], # Request mouse position
        [ "GetMouse",                    "get_mouse"                 , "getm",   "Gm"], # Curses should get button events, parameter #1 not documented.
        [ "SetAForeground",              "set_a_foreground"          , "setaf",  "AF"], # Set foreground color to #1, using ANSI escape
        [ "SetABackground",              "set_a_background"          , "setab",  "AB"], # Set background color to #1, using ANSI escape
        [ "PkeyPlab",                    "pkey_plab"                 , "pfxl",   "xl"], # Program function key #1 to type string #2 and show string #3
        [ "DeviceType",                  "device_type"               , "devt",   "dv"], # Indicate lan‐ guage/codeset sup‐ port
        [ "CodeSetInit",                 "code_set_init"             , "csin",   "ci"], # Init sequence for multiple codesets
        [ "Set0DesSeq",                  "set0_des_seq"              , "s0ds",   "s0"], # Shift to codeset 0 (EUC set 0, ASCII)
        [ "Set1DesSeq",                  "set1_des_seq"              , "s1ds",   "s1"], # Shift to codeset 1
        [ "Set2DesSeq",                  "set2_des_seq"              , "s2ds",   "s2"], # Shift to codeset 2
        [ "Set3DesSeq",                  "set3_des_seq"              , "s3ds",   "s3"], # Shift to codeset 3
        [ "SetLrMargin",                 "set_lr_margin"             , "smglr",  "ML"], # Set both left and right margins to #1, #2.  (ML is not in BSD term‐ cap).
        [ "SetTbMargin",                 "set_tb_margin"             , "smgtb",  "MT"], # Sets both top and bottom margins to #1, #2
        [ "BitImageRepeat",              "bit_image_repeat"          , "birep",  "Xy"], # Repeat bit image cell #1 #2 times
        [ "BitImageNewline",             "bit_image_newline"         , "binel",  "Zz"], # Move to next row of the bit image
        [ "BitImageCarriageReturn",      "bit_image_carriage_return" , "bicr",   "Yv"], # Move to beginning of same row
        [ "ColorNames",                  "color_names"               , "colornm","Yw"], # Give name for color #1
        [ "DefineBitImageRegion",        "define_bit_image_region"   , "defbi",  "Yx"], # Define rectan‐ gualar bit image region
        [ "EndBitImageRegion",           "end_bit_image_region"      , "endbi",  "Yy"], # End a bit-image region
        [ "SetColorBand",                "set_color_band"            , "setcolor","Yz"], # Change to ribbon color #1
        [ "SetPageLength",               "set_page_length"           , "slines", "YZ"], # Set page length to #1 lines
        [ "DisplayPcChar",               "display_pc_char"           , "dispc",  "S1"], # Display PC charac‐ ter #1
        [ "EnterPcCharsetMode",          "enter_pc_charset_mode"     , "smpch",  "S2"], # Enter PC character display mode
        [ "ExitPcCharsetMode",           "exit_pc_charset_mode"      , "rmpch",  "S3"], # Exit PC character display mode
        [ "EnterScancodeMode",           "enter_scancode_mode"       , "smsc",   "S4"], # Enter PC scancode mode
        [ "ExitScancodeMode",            "exit_scancode_mode"        , "rmsc",   "S5"], # Exit PC scancode mode
        [ "PcTermOptions",               "pc_term_options"           , "pctrm",  "S6"], # PC terminal options
        [ "ScancodeEscape",              "scancode_escape"           , "scesc",  "S7"], # Escape for scan‐ code emulation
        [ "AltScancodeEsc",              "alt_scancode_esc"          , "scesa",  "S8"], # Alternate escape for scancode emu‐ lation
        [ "EnterHorizontalHlMode",       "enter_horizontal_hl_mode"  , "ehhlm",  "Xh"], # Enter horizontal highlight mode
        [ "EnterLeftHlMode",             "enter_left_hl_mode"        , "elhlm",  "Xl"], # Enter left highlight mode
        [ "EnterLowHlMode",              "enter_low_hl_mode"         , "elohlm", "Xo"], # Enter low highlight mode
        [ "EnterRightHlMode",            "enter_right_hl_mode"       , "erhlm",  "Xr"], # Enter right high‐ light mode
        [ "EnterTopHlMode",              "enter_top_hl_mode"         , "ethlm",  "Xt"], # Enter top highlight mode
        [ "EnterVerticalHlMode",         "enter_vertical_hl_mode"    , "evhlm",  "Xv"], # Enter vertical high‐ light mode
        [ "SetAAttributes",              "set_a_attributes"          , "sgr1",   "sA"], # Define second set of video attributes #1-#6
        [ "SetPglenInch",                "set_pglen_inch"            , "slength","sL"], # YI Set page length to #1 hundredth of an inch
        [ "TermcapInit2",                "termcap_init2"             , "OTi2"], #  
        [ "TermcapReset",                "termcap_reset"             , "OTrs"], #  
        [ "LinefeedIfNotLf",             "linefeed_if_not_lf"        , "OTnl"], #  
        [ "BackspaceIfNotBs",            "backspace_if_not_bs"       , "OTbs"], #  
        [ "OtherNonFunctionKeys",        "other_non_function_keys"   , "OTko"], #  
        [ "ArrowKeyMap",                 "arrow_key_map"             , "OTma"], #  
        [ "AcsUlcorner",                 "acs_ulcorner"              , "OTG2"], #  
        [ "AcsLlcorner",                 "acs_llcorner"              , "OTG3"], #  
        [ "AcsUrcorner",                 "acs_urcorner"              , "OTG1"], #  
        [ "AcsLrcorner",                 "acs_lrcorner"              , "OTG4"], #  
        [ "AcsLtee",                     "acs_ltee"                  , "OTGR"], #  
        [ "AcsRtee",                     "acs_rtee"                  , "OTGL"], #  
        [ "AcsBtee",                     "acs_btee"                  , "OTGU"], #  
        [ "AcsTtee",                     "acs_ttee"                  , "OTGD"], #  
        [ "AcsHline",                    "acs_hline"                 , "OTGH"], #  
        [ "AcsVline",                    "acs_vline"                 , "OTGV"], #  
        [ "AcsPlus",                     "acs_plus"                  , "OTGC"], #  
        [ "MemoryLock",                  "memory_lock"               , "meml"], #  
        [ "MemoryUnlock",                "memory_unlock"             , "memu"], #  
        [ "BoxChars1",                   "box_chars_1"               , "box1"], #  
      ]

      create_all_from Table
    end

  end
end
