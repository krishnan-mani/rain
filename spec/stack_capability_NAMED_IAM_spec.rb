require_relative '../lib/independent_stack'

RSpec.describe IndependentStack do

  base_path = File.dirname(__FILE__)
  stack_artifacts_path = File.join(base_path, 'test-stack-capability-NAMED-IAM')
  stack = IndependentStack.new(stack_artifacts_path)
  client = Aws::CloudFormation::Client.new(region: 'ap-south-1')

  stack_name = 'test-stack-capability-NAMED-IAM'

  before(:each) do
    delete_stack(stack_name, client)
  end

  after(:each) do
    delete_stack(stack_name, client)
  end

  it 'creates a stack by specifying a capability of CAPABILITY_NAMED_IAM where required' do
    stack.process!
    stack_resource = Aws::CloudFormation::Resource.new(client: client)
    created_stack = stack_resource.stack(stack_name)
    expect(created_stack.stack_status).to match /CREATE/
  end

end