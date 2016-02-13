require "benchmark/ips"
require 'scanf'
require 'ruby_sscanf'

def use_scanf
  '12 34 56 89 1.234 1.0e10'.scanf('%d %d %d %d %f %f')
end

def use_ruby_sscanf
  '12 34 56 89 1.234 1.0e10'.sscanf('%d %d %d %d %f %f')
end

Benchmark.ips do |x|
  x.report("Scan strings with ruby_sscanf") { use_ruby_sscanf }
  x.report("Scan strings with scanf")       { use_scanf }
  x.compare!
end

