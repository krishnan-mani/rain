require_relative '../lib/environment_stack'

base_path = File.dirname(__FILE__)
stack_artifacts_path = File.join(base_path, 'test-stack-environment')

RSpec.describe EnvironmentStack do

  stack = EnvironmentStack.new(stack_artifacts_path, 'von')

  cf = Aws::CloudFormation::Client.new(region: 'ap-south-1')
  stack_name = 'test-stack-environment-environment-von-ap-south-1'

  before(:each) do
    cf.delete_stack(stack_name: stack_name)
  end

  after(:each) do
    cf.delete_stack(stack_name: stack_name)
  end

  it 'creates the stack for the specified environment' do
    stack.process!
    stack_resource = Aws::CloudFormation::Resource.new(client: cf)
    created_stack = stack_resource.stack(stack_name)
    expect(created_stack.stack_status).to match /CREATE/
  end

end