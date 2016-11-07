require_relative '../lib/independent_stack'

base_path = File.dirname(__FILE__)
stack_artifacts_path = File.join(base_path, 'test-stack')
stack = IndependentStack.new(stack_artifacts_path)
client = Aws::CloudFormation::Client.new(region: 'ap-south-1')

stack_name = 'test-stack'

RSpec.describe IndependentStack do

  after(:each) do
    delete_stack(stack_name, client)
  end

  it 'for create action, the stack is created if it does not exist' do
    client.delete_stack(stack_name: stack_name)
    stack.process!

    stack_resource = Aws::CloudFormation::Resource.new(client: client)
    stack = stack_resource.stack(stack_name)
    stack.wait_until(max_attempts: 10, delay: 5) { |stack| stack.stack_status == 'CREATE_COMPLETE' }

    expect(stack.stack_status).to eql 'CREATE_COMPLETE'
  end
end

RSpec.describe IndependentStack do

  it 'for create action, a change-set is created for the stack if it exists' do
    :pending
  end

end