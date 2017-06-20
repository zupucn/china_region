require "bundler/gem_tasks"
require "rspec/core/rake_task"

RSpec::Core::RakeTask.new(:spec)

task :default => :spec

desc 'Run Slim benchmarks! (default parameters slow=false)'
task :bench do
  ruby('benchmarks/run-benchmarks.rb')
end
