require_relative '../lib/independent_stack'

RSpec.describe "process a template" do

  base_name = File.dirname(__FILE__)
  stack_name = 'test-stack-delete-on-failure'
  artifacts_path = File.join(base_name, stack_name)
  client = Aws::CloudFormation::Client.new(region: 'ap-south-1')

  it 'deletes the stack if a failure occurs when creating the stack' do
    stack = IndependentStack.new(artifacts_path)
    begin
      stack.process!
    rescue Aws::Waiters::Errors::FailureStateError => ex
      puts "#{ex.message}"
    end
    client.wait_until(:stack_delete_complete, stack_name: stack_name)
  end

end