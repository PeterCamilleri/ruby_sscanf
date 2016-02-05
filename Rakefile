#!/usr/bin/env rake
# coding: utf-8

require 'rake/testtask'
require 'rdoc/task'
require "bundler/gem_tasks"

#Generate internal documentation with rdoc.
RDoc::Task.new do |rdoc|
  rdoc.rdoc_dir = "rdoc"

  #List out all the files to be documented.
  rdoc.rdoc_files.include("lib/**/*.rb", "license.txt", "README.md")

  #Make all access levels visible.
  rdoc.options << '--visibility' << 'private'
  #rdoc.options << '--verbose'
  #rdoc.options << '--coverage-report'

  #Set a title.
  rdoc.options << '--title' << 'fOOrth Language Internals'

end

#Run the format_engine unit test suite.
Rake::TestTask.new do |t|
  #List out all the test files.
  t.test_files = FileList['tests/**/*.rb']
  t.verbose = false
end

desc "Run a scan for smelly code!"
task :reek do |t|
  `reek --no-color lib > reek.txt`
end

desc "Run an IRB Session with format_engine loaded."
task :console do
  require 'irb'
  require 'irb/completion'
  require './lib/ruby_sscanf'
  puts "Starting an IRB console with ruby_sscanf."
  puts "Use 'quit' to exit."
  puts
  ARGV.clear
  IRB.start
end

desc "What version of code is this?"
task :vers do |t|
  puts
  puts "ruby_sscanf version = #{RubySscanf::VERSION}"
end


