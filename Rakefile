require 'rubygems'
require 'bundler'
Bundler::GemHelper.install_tasks

require 'rake'
require "rake/rdoctask"

require 'rspec'
require 'rspec/core/rake_task'

desc "Run all specs"
Rspec::Core::RakeTask.new(:spec) do |spec|
  spec.rspec_opts = ["--color"]
  spec.pattern = 'spec/**/*_spec.rb'
end

desc "Print specdocs"
Rspec::Core::RakeTask.new(:doc) do |spec|
  spec.rspec_opts = ["--format", "specdoc"]
  spec.pattern = 'spec/*_spec.rb'
end

desc "Generate the rdoc"
Rake::RDocTask.new do |rdoc|
  files = ["README.rdoc", "LICENSE", "lib/**/*.rb"]
  rdoc.rdoc_files.add(files)
  rdoc.main = "README.rdoc"
  rdoc.title = "CouchRest Localised Properties Extension"
end

desc "Run the rspec"
task :default => :spec
