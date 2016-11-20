require_relative '../lib/independent_stack'


base_path = File.dirname(__FILE__)
stack_artifacts_path = File.join(base_path, 'test-stack')
client = Aws::CloudFormation::Client.new(region: 'ap-south-1')
stack_resource = Aws::CloudFormation::Resource.new(client: client)

RSpec.describe 'process a template' do

  stack_name = 'test-stack'

  before(:each) do
    client.delete_stack(stack_name: stack_name)
    client.wait_until(:stack_delete_complete, stack_name: stack_name)
  end

  it 'creates the stack' do
    stack = IndependentStack.new(stack_artifacts_path)
    stack.create!
    created_stack = stack_resource.stack(stack_name)
    expect(created_stack.stack_status).to match /CREATE/
  end

end

