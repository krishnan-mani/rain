require_relative '../lib/independent_stack'

base_path = File.dirname(__FILE__)
stack_artifacts_path = File.join(base_path, 'test-stack-change-set')
stack = IndependentStack.new(stack_artifacts_path)
client = Aws::CloudFormation::Client.new(region: 'ap-south-1')

stack_name = 'test-stack-change-set'

RSpec.describe IndependentStack do

  after(:each) do
    delete_stack(stack_name, client)
  end

  it 'for create action, a change-set is created for the stack if it exists' do
    stack.process!
    stack_resource = Aws::CloudFormation::Resource.new(client: client)
    created_stack = stack_resource.stack(stack_name)
    created_stack.wait_until(max_attempts: 10, delay: 5) { |stack| stack.stack_status == 'CREATE_COMPLETE' }

    stack.process!
    response = client.list_change_sets(stack_name: stack_name)
    p response.summaries
    expect(response.summaries.length).to eql 1
  end

end