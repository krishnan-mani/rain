require_relative '../lib/stack_lifecycle'


base_path = File.dirname(__FILE__)
stack_artifacts_path = File.join(base_path, 'test-stack-parameters-file')
stack = StackLifecycle.new(stack_artifacts_path)
client = Aws::CloudFormation::Client.new(region: 'ap-south-1')

RSpec.describe StackLifecycle do

  stack_name = 'test-stack-parameters-file-dev-ap-south-1'

  before(:each) do
    delete_stack(stack_name, client)
  end

  after(:each) do
    delete_stack(stack_name, client)
  end

  it 'reads a parameters file and creates stack' do
    stack.process!
    stack_resource = Aws::CloudFormation::Resource.new(client: client)
    created_stack = stack_resource.stack(stack_name)
    expect(created_stack.stack_status).to match /CREATE/
  end

end