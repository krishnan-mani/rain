require 'ci/reporter/rake/rspec'

require_relative 'lib/independent_stack'
require_relative 'lib/context_stack'
require_relative 'lib/print_module'


desc "describe. For e.g.: rake describe[/Users/krishman/development/products/rain/spec/test-stack]"
task :describe, [:artifacts_path] do |t, args|
  stack = IndependentStack.new(args.artifacts_path)
  puts PrintModule.print_metadata(stack.metadata)
end

desc "process_for_context"
task :process_for_context, [:artifacts_path, :context_name, :s3_bucket, :s3_region] do |t, args|
  path = args.artifacts_path
  context_name = args.context_name
  s3_bucket, s3_region = args.s3_bucket, args.s3_region
  stack = ContextStack.new(path, context_name, {s3Location: s3_bucket, s3Region: s3_region})
  stack.process!
end

desc "process"
task :process, [:artifacts_path, :s3_bucket, :s3_region] do |t, args|
  path = args.artifacts_path || File.dirname(__FILE__)
  s3_bucket, s3_region = args.s3_bucket, args.s3_region
  stack = IndependentStack.new(path, {s3Location: s3_bucket, s3_region: s3_region})
  stack.process!
end

begin
  require 'rspec/core/rake_task'
  RSpec::Core::RakeTask.new(:spec)

rescue LoadError
  # no rspec available
end

task :spec => 'ci:setup:rspec'