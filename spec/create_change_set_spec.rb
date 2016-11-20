require_relative '../lib/independent_stack'

base_path = File.dirname(__FILE__)
stack_artifacts_path = File.join(base_path, 'test-stack-change-set')
stack = IndependentStack.new(stack_artifacts_path)
client = Aws::CloudFormation::Client.new(region: 'ap-south-1')


RSpec.describe 'process a template' do

  stack_name = 'test-stack-change-set'

  before(:each) do
    delete_stack(stack_name, client)
    client.wait_until(:stack_delete_complete, stack_name: stack_name)
  end

  it 'for create action, a change-set is created for the stack if it already exists' do
    stack.process!
    client.wait_until(:stack_create_complete, stack_name: stack_name)

    stack.process!
    response = client.list_change_sets(stack_name: stack_name)
    expect(response.summaries.length).to eql 1
  end

end