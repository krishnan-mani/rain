require_relative '../lib/context_stack'

base_path = File.dirname(__FILE__)
stack_artifacts_path = File.join(base_path, 'test-stack-context')

RSpec.describe "process a template" do

  stack = ContextStack.new(stack_artifacts_path, 'foo')

  client = Aws::CloudFormation::Client.new(region: 'ap-south-1')
  stack_name = 'test-stack-context-context-foo-ap-south-1'

  before(:each) do
    client.delete_stack(stack_name: stack_name)
    client.wait_until(:stack_delete_complete, stack_name: stack_name)
  end

  it 'creates a stack for the specified context' do
    stack.process!
    stack_resource = Aws::CloudFormation::Resource.new(client: client)
    created_stack = stack_resource.stack(stack_name)
    expect(created_stack.stack_status).to match /CREATE/
  end

end