require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'

desc 'Default: run unit tests.'
task :default => :test

desc 'Test the simple_audit plugin.'
Rake::TestTask.new(:test) do |t|
  t.libs << 'lib'
  t.libs << 'test'
  t.pattern = 'test/**/*_test.rb'
  t.verbose = true
end

desc 'Generate documentation for the simple_audit plugin.'
Rake::RDocTask.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = 'SimpleAudit'
  rdoc.options << '--line-numbers' << '--inline-source'
  rdoc.rdoc_files.include('README')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

#
# Gemify
#
begin
  require 'jeweler'
  test_files = FileList['test/**/*'].to_a
  gem_files = FileList[
    '[a-zA-Z]*',
    'lib/**/*',
    'generators/**/*',
    'rails/**/*',
  ].to_a + test_files
  
  Jeweler::Tasks.new do |gemspec|
    gemspec.name = "simple_audit"
    gemspec.summary = "Simple auditing solution for ActiveRecord models"
    gemspec.description = <<-EOD 
      Provides a straightforward way for auditing changes on active record models, especially for composite entities. 
      Also provides helper methods for easily rendering an audit trail in Ruby on Rails views.
    EOD
    gemspec.email = ["gabriel.tarnovan@cubus.ro", "mihai.tarnovan@cubus.ro"]
    gemspec.homepage = "http://github.com/gtarnovan/simple_audit"
    gemspec.authors = ["Gabriel Tarnovan", "Mihai Tarnovan"]
    gemspec.version = "0.2.0"
    gemspec.files = gem_files
    gemspec.test_files = test_files
    
    gemspec.rubyforge_project = 'simple_audit'
  end
rescue LoadError
  puts "Jeweler not available. Install it with: gem install jeweler"
end