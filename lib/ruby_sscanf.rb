require 'format_engine'
require_relative 'ruby_sscanf/version'

#The String class is monkey patched to support sscanf.
class String

  #A regular expression for decimal integers.
  RSF_DECIMAL  = /[+-]?\d+/

  #A regular expression for unsigned decimal integers.
  RSF_UNSIGNED = /[+]?\d+/

  #A regular expression for hexadecimal integers.
  RSF_HEX      = /[+-]?(0[xX])?\h+/
  RSF_HEX_PARSE = lambda {parse(RSF_HEX) ? dst << found.to_i(16) : :break}
  RSF_HEX_SKIP  = lambda {parse(RSF_HEX) || :break}

  #A regular expression for octal integers.
  RSF_OCTAL    = /[+-]?(0[oO])?[0-7]+/

  #A regular expression for binary integers.
  RSF_BINARY   = /[+-]?(0[bB])?[01]+/

  #A regular expression for flexible base integers.
  RSF_INTEGER  = /[+-]?((0[xX]\h+)|(0[bB][01]+)|(0[oO]?[0-7]*)|([1-9]\d*))/

  #A regular expression for floating point and scientific notation numbers.
  RSF_FLOAT    = /[+-]?\d+(\.\d+)?([eE][+-]?\d+)?/
  RSF_FLOAT_PARSE = lambda {parse(RSF_FLOAT) ? dst << found.to_f : :break}
  RSF_FLOAT_SKIP  = lambda {parse(RSF_FLOAT) || :break}

  #A regular expression for rational numbers.
  RSF_RATIONAL = /[+-]?\d+\/\d+(r)?/

  #A regular expression for complex numbers.
  RSF_COMPLEX  = %r{(?<num> \d+(\.\d+)?([eE][+-]?\d+)?){0}
                    [+-]?\g<num>[+-]\g<num>[ij]
                   }x

  #A regular expression for a string.
  RSF_STRING   = /\S+/

  #A regular expression for quoted strings.
  RSF_QUOTED   = /("([^\\"]|\\.)*")|('([^\\']|\\.)*')/

  #The standard handlers for formats with embedded regular expressions.
  RSF_RGX      = lambda {parse(fmt.regex) ? dst << found : :break}
  RSF_RGX_SKIP = lambda {parse(fmt.regex) || :break}


  #Get the parsing engine. This is cached on a per-thread basis. That is to
  #say, each thread gets its own \FormatEngine::Engine instance.
  def self.get_parser_engine

    Thread.current[:ruby_sscanf_engine] ||= FormatEngine::Engine.new(
      "%a"  => RSF_FLOAT_PARSE,
      "%*a" => RSF_FLOAT_SKIP,

      "%A"  => RSF_FLOAT_PARSE,
      "%*A" => RSF_FLOAT_SKIP,

      "%b"  => lambda {parse(RSF_BINARY) ? dst << found.to_i(2) : :break},
      "%*b" => lambda {parse(RSF_BINARY) || :break},

      "%c"  => lambda {dst << grab},
      "%*c" => lambda {grab},

      "%d"  => lambda {parse(RSF_DECIMAL) ? dst << found.to_i : :break},
      "%*d" => lambda {parse(RSF_DECIMAL) || :break},

      "%e"  => RSF_FLOAT_PARSE,
      "%*e" => RSF_FLOAT_SKIP,

      "%E"  => RSF_FLOAT_PARSE,
      "%*E" => RSF_FLOAT_SKIP,

      "%f"  => RSF_FLOAT_PARSE,
      "%*f" => RSF_FLOAT_SKIP,

      "%F"  => RSF_FLOAT_PARSE,
      "%*F" => RSF_FLOAT_SKIP,

      "%g"  => RSF_FLOAT_PARSE,
      "%*g" => RSF_FLOAT_SKIP,

      "%G"  => RSF_FLOAT_PARSE,
      "%*G" => RSF_FLOAT_SKIP,

      "%i"  => lambda {parse(RSF_INTEGER) ? dst << found.to_i(0) : :break},
      "%*i" => lambda {parse(RSF_INTEGER) || :break},

      "%j"  => lambda {parse(RSF_COMPLEX) ? dst << Complex(found) : :break},
      "%*j" => lambda {parse(RSF_COMPLEX) || :break},

      "%o"  => lambda {parse(RSF_OCTAL) ? dst << found.to_i(8) : :break},
      "%*o" => lambda {parse(RSF_OCTAL) || :break},

      "%q"  => lambda do
        if parse(RSF_QUOTED)
          dst << found[1..-2].gsub(/\\./) {|seq| seq[-1]}
        else
          :break
        end
      end,

      "%*q" => lambda {parse(RSF_QUOTED) || :break},

      "%r"  => lambda {parse(RSF_RATIONAL) ? dst << found.to_r : :break},
      "%*r" => lambda {parse(RSF_RATIONAL) || :break},

      "%s"  => lambda {parse(RSF_STRING) ? dst << found : :break},
      "%*s" => lambda {parse(RSF_STRING) || :break},

      "%u"  => lambda {parse(RSF_UNSIGNED) ? dst << found.to_i : :break},
      "%*u" => lambda {parse(RSF_UNSIGNED) || :break},

      "%x"  => RSF_HEX_PARSE,
      "%*x" => RSF_HEX_SKIP,

      "%X"  => RSF_HEX_PARSE,
      "%*X" => RSF_HEX_SKIP,

      "%["  => RSF_RGX,
      "%*[" => RSF_RGX_SKIP,

      "%/"  => RSF_RGX,
      "%*/" => RSF_RGX_SKIP)
  end

  #Scan the formatted input.
  def sscanf(format)
    String.get_parser_engine.do_parse(self, [], format)
  end

end
