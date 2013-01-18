require "bundler/gem_tasks"
require 'cucumber'
require 'cucumber/rake/task'
require 'rspec/core/rake_task'

Cucumber::Rake::Task.new(:features, "Run all features") do |t|
  t.profile = 'default'
end

RSpec::Core::RakeTask.new(:spec) do |spec|
  spec.ruby_opts = "-I lib:spec"
  spec.pattern = 'spec/**/*_spec.rb'
end
task :spec

desc 'Run all specs and features'
task :test => %w[spec features]

task :default => :test
