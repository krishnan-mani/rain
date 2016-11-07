require_relative '../lib/context_stack'

base_path = File.dirname(__FILE__)
stack_artifacts_path = File.join(base_path, 'test-stack-context')

RSpec.describe ContextStack do

  stack = ContextStack.new(stack_artifacts_path, 'foo')

  cf = Aws::CloudFormation::Client.new(region: 'ap-south-1')
  stack_name = 'test-stack-context-context-foo-ap-south-1'

  before(:each) do
    cf.delete_stack(stack_name: stack_name)
  end

  after(:each) do
    cf.delete_stack(stack_name: stack_name)
  end

  it 'creates the stack for the specified context' do
    stack.process!
    stack_resource = Aws::CloudFormation::Resource.new(client: cf)
    created_stack = stack_resource.stack(stack_name)
    expect(created_stack.stack_status).to match /CREATE/
  end

end