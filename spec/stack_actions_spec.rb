require 'aws-sdk'

require_relative '../lib/stack_lifecycle'


base_path = File.dirname(__FILE__)
stack_artifacts_path = File.join(base_path, 'test-stack-create')
stack = StackLifecycle.new(stack_artifacts_path, 'dev')

RSpec.describe StackLifecycle do

  it 'implements the stack create action when there is no stack', focus: true do
    stack.process!
    cf = Aws::CloudFormation::Client.new(region: 'ap-south-1')
    stack_resource = Aws::CloudFormation::Resource.new(client: cf)
    created_stack = stack_resource.stack('test-stack-create-dev-ap-south-1')
    expect(created_stack.stack_status).to match /CREATE/
  end

  it 'reports an error for the stack create action when there is a pre-existing stack' do
    :pending
  end

end