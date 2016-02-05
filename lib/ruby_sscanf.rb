
require 'format_engine'
require_relative 'ruby_sscanf/version'

class String

  DECIMAL  = /[+-]?\d+/
  HEX      = /[+-]?(0[xX])?\h+/
  OCTAL    = /[+-]?(0[oO])?[0-7]+/
  BINARY   = /[+-]?(0[bB])?[01]+/
  INTEGER  = /[+-]?((0[xX]\h+)|(0[bB][01]+)|(0[oO]?[0-7]*)|([1-9]\d*))/
  FLOAT    = /[+-]?\d+(\.\d+)?([eE][+-]?\d+)?/
  RATIONAL = /[+-]?\d+\/\d+(r)?/
  COMPLEX  = %r{(?<num> \d+(\.\d+)?([eE][+-]?\d+)?){0}
                [+-]?\g<num>[+-]\g<num>[ij]
               }x
  QUOTED   = /("([^\\"]|\\.)*")|('([^\\']|\\.)*')/

  #Get the parsing engine.
  def self.get_engine
    Thread.current[:ruby_sscanf_engine] ||= FormatEngine::Engine.new(
      "%b"  => lambda {parse(BINARY) ? dst << found.to_i(2) : :break},
      "%*b" => lambda {parse(BINARY) || :break},

      "%c"  => lambda {dst << grab},
      "%*c" => lambda {grab},

      "%d"  => lambda {parse(DECIMAL) ? dst << found.to_i : :break},
      "%*d" => lambda {parse(DECIMAL) || :break},

      "%f"  => lambda {parse(FLOAT) ? dst << found.to_f : :break},
      "%*f" => lambda {parse(FLOAT) || :break},

      "%i"  => lambda {parse(INTEGER) ? dst << found.to_i(0) : :break},
      "%*i" => lambda {parse(INTEGER) || :break},

      "%j"  => lambda {parse(COMPLEX) ? dst << Complex(found) : :break},
      "%*j" => lambda {parse(COMPLEX) || :break},

      "%o"  => lambda {parse(OCTAL) ? dst << found.to_i(8) : :break},
      "%*o" => lambda {parse(OCTAL) || :break},

      "%q"  => lambda do
        parse(QUOTED) ? dst << found[1..-2].gsub(/\\./) {|seq| seq[-1]} : :break
      end,
      "%*q" => lambda {parse(QUOTED) || :break},

      "%r"  => lambda {parse(RATIONAL) ? dst << found.to_r : :break},
      "%*r" => lambda {parse(RATIONAL) || :break},

      "%s"  => lambda {parse(/\S+/) ? dst << found : :break},
      "%*s" => lambda {parse(/\S+/) || :break},

      "%u"  => lambda {parse(/\d+/) ? dst << found.to_i : :break},
      "%*u" => lambda {parse(/\d+/) || :break},

      "%x"  => lambda {parse(HEX) ? dst << found.to_i(16) : :break},
      "%*x" => lambda {parse(HEX) || :break},

      "%["  => lambda {parse(fmt.regex) ? dst << found : :break},
      "%*[" => lambda {parse(fmt.regex) || :break})
  end

  #Scan the formatted input.
  def sscanf(format)
    String.get_engine.do_parse(self, [], format)
  end

end
