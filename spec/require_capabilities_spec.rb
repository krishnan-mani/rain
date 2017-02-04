require_relative '../lib/independent_stack'

RSpec.describe 'for stacks that require one or more capabilities' do

  base_path = File.dirname(__FILE__)
  stack_artifacts_path = File.join(base_path, 'test-stack-capability-IAM')
  client = Aws::CloudFormation::Client.new(region: 'ap-south-1')
  stack_resource = Aws::CloudFormation::Resource.new(client: client)
  stack_name = 'test-stack-capability-IAM'

  it 'supplies the capability as specified in meta-data' do
    stack = IndependentStack.new(stack_artifacts_path)
    stack.process!
    created_stack = stack_resource.stack(stack_name)
    expect(created_stack.stack_status).to match /CREATE/
  end

end