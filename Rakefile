require "bundler/gem_tasks"
require "rspec/core/rake_task"

RSpec::Core::RakeTask.new(:spec)

task :default => :spec

desc 'Run ChinaRegion benchmarks! '
task :bench do
  ruby('benchmarks/run-benchmarks.rb')
end
