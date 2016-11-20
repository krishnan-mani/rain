require 'aws-sdk'

require_relative '../lib/independent_stack'


base_path = File.dirname(__FILE__)
stack_name = 'test-stack-create'
stack_artifacts_path = File.join(base_path, stack_name)
stack = IndependentStack.new(stack_artifacts_path)

client = Aws::CloudFormation::Client.new(region: 'ap-south-1')
stack_resource = Aws::CloudFormation::Resource.new(client: client)

RSpec.describe 'process a template' do

  it 'creates a stack for the stack create action, when there is none' do
    client.delete_stack(stack_name: stack_name)
    client.wait_until(:stack_delete_complete, stack_name: stack_name)

    stack.process!
    created_stack = stack_resource.stack(stack_name)
    expect(created_stack.stack_status).to match /CREATE/
  end

end