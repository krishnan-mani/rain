require_relative '../lib/independent_stack'

base_path = File.dirname(__FILE__)
stack_artifacts_path = File.join(base_path, 'test-stack-process')
stack = IndependentStack.new(stack_artifacts_path)
client = Aws::CloudFormation::Client.new(region: 'ap-south-1')

stack_name = 'test-stack-process'

RSpec.describe "process templates" do

  it 'for a stack action of create, the stack is created if it does not exist' do
    client.delete_stack(stack_name: stack_name)
    client.wait_until(:stack_delete_complete, stack_name: stack_name)

    stack.process!
    client.wait_until(:stack_create_complete, stack_name: stack_name)
  end
  
  after(:each) do
    delete_stack(stack_name, client)
  end

end

