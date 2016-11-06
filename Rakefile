require 'ci/reporter/rake/rspec'

require_relative 'lib/stack_lifecycle'
require_relative 'lib/print_module'


desc "describe. For e.g.: rake describe[/Users/krishman/development/products/rain/spec/test-stack]"
task :describe, [:artifacts_path] do |t, args|
  stack = StackLifecycle.new(args.artifacts_path)
  puts PrintModule.print_metadata(stack.metadata)
end

desc "process_for_context"
task :process_for_context, [:artifacts_path, :context_name] do |t, args|
  path = args.artifacts_path
  context_name = args.context_name
  stack = StackLifecycle.new(path)
  stack.process_for_context(context_name)
end

desc "process"
task :process, [:artifacts_path] do |t, args|
  path = args.artifacts_path || File.dirname(__FILE__)
  stack = StackLifecycle.new(path)
  stack.process!
end


begin
  require 'rspec/core/rake_task'
  RSpec::Core::RakeTask.new(:spec)

rescue LoadError
  # no rspec available
end

task :spec => 'ci:setup:rspec'