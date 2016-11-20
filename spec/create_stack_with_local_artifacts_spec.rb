require_relative '../lib/independent_stack'


base_path = File.dirname(__FILE__)
stack_artifacts_path = File.join(base_path, 'test-stack-local')
client = Aws::CloudFormation::Client.new(region: 'ap-south-1')
stack_resource = Aws::CloudFormation::Resource.new(client: client)


RSpec.describe 'process a template' do

  stack_name = 'test-stack-local'

  before(:each) do
    delete_stack(stack_name, client)
    client.wait_until(:stack_delete_complete, stack_name: stack_name)
  end

  it 'creates stack using local template artifacts' do
    stack = IndependentStack.new(stack_artifacts_path)
    stack.process!
    created_stack = stack_resource.stack(stack_name)
    expect(created_stack.stack_status).to match /CREATE/
  end

end