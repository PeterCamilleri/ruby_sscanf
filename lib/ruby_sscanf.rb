require 'format_engine'
require_relative 'ruby_sscanf/engine'
require_relative 'ruby_sscanf/version'

#The String class is monkey patched to support sscanf.
class String

  #Scan the formatted input.
  def sscanf(format)
    String.get_parser_engine.do_parse(self, [], format)
  end

  #Get any unparsed text.
  def self.sscanf_unparsed
    get_parser_engine.unparsed
  end

end
