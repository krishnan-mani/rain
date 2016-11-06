require 'aws-sdk'

require_relative '../lib/stack_lifecycle'


base_path = File.dirname(__FILE__)
stack_name = 'test-stack-create'
stack_artifacts_path = File.join(base_path, stack_name)
stack = StackLifecycle.new(stack_artifacts_path)

cf = Aws::CloudFormation::Client.new(region: 'ap-south-1')
stack_resource = Aws::CloudFormation::Resource.new(client: cf)

RSpec.describe StackLifecycle do

  before(:each) do
    delete_stack(stack_name, cf)
  end

  after(:each) do
    delete_stack(stack_name, cf)
  end

  it 'implements the stack create action when there is no stack' do
    stack.process!
    created_stack = stack_resource.stack(stack_name)
    expect(created_stack.stack_status).to match /CREATE/
  end

end