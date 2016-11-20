require_relative '../lib/environment_stack'

base_path = File.dirname(__FILE__)
stack_artifacts_path = File.join(base_path, 'test-stack-environment')
client = Aws::CloudFormation::Client.new(region: 'ap-south-1')
stack_resource = Aws::CloudFormation::Resource.new(client: client)

RSpec.describe "process template by environment" do

  stack = EnvironmentStack.new(stack_artifacts_path, 'von')
  stack_name = 'test-stack-environment-environment-von-ap-south-1'

  before(:each) do
    client.delete_stack(stack_name: stack_name)
    client.wait_until(:stack_delete_complete, stack_name: stack_name)
  end

  it 'creates a stack for the specified environment' do
    stack.process!
    created_stack = stack_resource.stack(stack_name)
    expect(created_stack.stack_status).to match /CREATE/
  end

end