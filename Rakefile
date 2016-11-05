require 'ci/reporter/rake/rspec'

require_relative 'lib/stack_lifecycle'
require_relative 'lib/print_module'

desc 'describe'
task :describe do
  base_path = File.dirname(__FILE__)
  stack_artifacts_path = File.join(base_path, 'spec', 'test-stack')
  stack = StackLifecycle.new(stack_artifacts_path, "dev")
  puts PrintModule.print_metadata(stack.metadata)
end

begin
  require 'rspec/core/rake_task'
  RSpec::Core::RakeTask.new(:spec)

rescue LoadError
  # no rspec available
end

task :spec => 'ci:setup:rspec'