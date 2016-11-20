require_relative '../lib/independent_stack'


base_path = File.dirname(__FILE__)
stack_artifacts_path = File.join(base_path, 'test-stack-capability-IAM')
stack = IndependentStack.new(stack_artifacts_path)
client = Aws::CloudFormation::Client.new(region: 'ap-south-1')

RSpec.describe IndependentStack do
  stack_name = 'test-stack-capability-IAM'

  before(:each) do
    delete_stack(stack_name, client)
  end

  it 'creates a stack by specifying a capability of CAPABILITY_IAM where required' do
    stack.process!
    stack_resource = Aws::CloudFormation::Resource.new(client: client)
    created_stack = stack_resource.stack(stack_name)
    expect(created_stack.stack_status).to match /CREATE/
  end

end