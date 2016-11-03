require 'ci/reporter/rake/rspec'

begin
  require 'rspec/core/rake_task'
  RSpec::Core::RakeTask.new(:spec)

  task :default => :spec
rescue LoadError
  # no rspec available
end

task :spec => 'ci:setup:rspec'