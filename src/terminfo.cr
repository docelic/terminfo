require "log"
Log.setup_from_env

require "./capabilities"
require "./term"
require "./storage"

class Terminfo
  Log = ::Log.for "terminfo"
  VERSION_MAJOR = 0
  VERSION_MINOR = 9
  VERSION_REVISION = 0
  VERSION = "#{VERSION_MAJOR}.#{VERSION_MINOR}.#{VERSION_REVISION}"

  # Terminfo extended parsing flag. If this flag is true and
  # extended sections exist in terminfo files, they will be
  # parsed.
  class_property? extended = true

  # List of default directories to search for terminfo files
  class_getter directories : Array(String) {
    dirs = [] of String
    (ENV["TERMINFO"]?).try      { |i| dirs.push i }
    (ENV["TERMINFO_DIRS"]?).try { |i| dirs += i.split ':' }
    (ENV["HOME"]?).try          { |i| dirs.push "#{i}/.terminfo" }
    dirs.push \
      "/etc/terminfo",
      "/lib/terminfo",
      "/usr/share/terminfo",
      "/usr/share/lib/terminfo",
      "/usr/lib/terminfo",
      "/usr/local/share/terminfo",
      "/usr/local/share/lib/terminfo",
      "/usr/local/lib/terminfo",
      "/usr/local/ncurses/lib/terminfo",
      "/boot/system/data/terminfo"
    Log.debug { "Terminfo directories: #{dirs.inspect}" }
    dirs
  }

  getter data
  getter capabilities = Capabilities::Data.new

  # Create Terminfo object after auto-detecting current term name
  def initialize(extended = Terminfo.extended?)
    Log.debug { "Init without arguments, will try to autodetect terminal type" }
    if filename = ENV["TERMINFO"]?
      Log.debug { "Autodetect: TERMINFO=#{filename.inspect}" }
      initialize path: filename, extended: extended
    elsif term = ENV["TERM"]?
      Log.debug { "Autodetect: TERM=#{term.inspect}" }
      initialize term: term, extended: extended
    else
      term = "{% if flag?(:windows) %}windows-ansi{% else %}xterm{% end %}"
      Log.debug { "Autodetect: using default term=#{term.inspect}" }
      initialize term: term, extended: extended
    end
  end

  def initialize(*, term : String, extended = Terminfo.extended?)
    filename = nil
    # scan all possible locations
    ::Terminfo.directories.each do |dir|
      locations = [
        File.join(dir, term),                                 # /path/to/terminfo/screen
        File.join(dir, term[0..0], term),                     # /path/to/terminfo/s/screen
        File.join(dir, term[0..0], term[0..1], term),         # /path/to/terminfo/s/sc/screen
        File.join(dir, sprintf("%x", term[0..0].bytes), term) # /path/to/terminfo/73/screen, see https://invisible-island.net/ncurses/NEWS.html#t20071117
      ]
      break if filename = locations.find{|loc| File.file?(loc) && File.readable?(loc)}
    end

    if filename
      initialize path: filename, extended: extended
    else
      if ::Terminfo::Storage.has_internal? term
        initialize builtin: term, extended: extended
      else
        raise Exception.new "Can't find system or builtin terminfo file for '#{term}'"
      end
    end
  end

  def initialize(*, builtin : String, extended = Terminfo.extended?)
    @file = builtin
    Log.debug { "Using builtin terminfo file #{@file.inspect}" }
    @data = Term.new io: ::IO::Memory.new(::Terminfo::Storage.get_internal(builtin).read), extended: extended
  end
  def initialize(*, path : String, extended = Terminfo.extended?)
    @file = path
    Log.debug { "Using terminfo file #{@file.inspect}" }
    @data = File.open(path) do |io| Term.new io: io, extended: extended end
  end
  def initialize(*, file : File, extended = Terminfo.extended?)
    @file = file.path
    Log.debug { "Using terminfo file #{@file.inspect}" }
    @data = Term.new io: File, extended: extended
  end
end
