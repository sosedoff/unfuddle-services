require 'bundler'
require "rspec/core/rake_task"

RSpec::Core::RakeTask.new(:test) do |t|
  t.pattern = 'spec/*_spec.rb'
  t.verbose = false
end

task :default => :test

task :setup do
  # TODO: Init configs and other stuff
end
