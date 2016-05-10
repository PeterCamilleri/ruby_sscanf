# coding: utf-8
# An IRB + ruby_sscanf test bed

require 'irb'
$force_alias_read_line_module = true
require 'mini_readline'

puts "Starting an IRB console with ruby_sscanf loaded."

if ARGV[0] == 'local'
  require_relative 'lib/ruby_sscanf'
  puts "ruby_sscanf loaded locally: #{RubySscanf::VERSION}"

  ARGV.shift
else
  require 'ruby_sscanf'
  puts "ruby_sscanf loaded from gem: #{RubySscanf::VERSION}"
end

IRB.start
