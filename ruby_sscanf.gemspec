# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ruby_sscanf/version'

Gem::Specification.new do |spec|
  spec.name          = "ruby_sscanf"
  spec.version       = RubySscanf::VERSION
  spec.authors       = ["Peter Camilleri"]
  spec.email         = ["peter.c.camilleri@gmail.com"]

  spec.summary       = "A string parser."
  spec.description   = "A formatted string data parser for Ruby"
  spec.homepage      = "https://github.com/PeterCamilleri/ruby_sscanf"
  spec.license       = "MIT"

  raw_list           = `git ls-files`.split($/)
  spec.files         = raw_list.keep_if {|entry| !entry.start_with?("docs") }
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.required_ruby_version = '>= 1.9.3'

  spec.add_runtime_dependency "format_engine", "~> 0.7.2"

  spec.add_development_dependency "rake", "~> 12.0"
  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency 'minitest', "~> 5.7"
  spec.add_development_dependency 'minitest_visible', "~> 0.1"
  spec.add_development_dependency 'rdoc', "~> 5.0"

end
