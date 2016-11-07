require_relative '../lib/independent_stack'

base_path = File.dirname(__FILE__)
stack_artifacts_path = File.join(base_path, 'test-stack')

RSpec.describe IndependentStack do

  stack = IndependentStack.new(stack_artifacts_path)

  it 'obtains the stack information from metadata' do
    expect(stack.metadata["name"]).to eql('test-stack')
  end

  it 'constructs a name for the realized stack based on the environment and region' do
    expect(stack.stack_name).to eql('test-stack')
  end

end


RSpec.describe 'it creates stack' do

  stack = IndependentStack.new(stack_artifacts_path)

  cf = Aws::CloudFormation::Client.new(region: 'ap-south-1')
  stack_name = 'test-stack'

  before(:each) do
    cf.delete_stack(stack_name: stack_name)
  end

  after(:each) do
    cf.delete_stack(stack_name: stack_name)
  end

  it 'creates the stack' do
    stack.create!
    stack_resource = Aws::CloudFormation::Resource.new(client: cf)
    created_stack = stack_resource.stack(stack_name)
    expect(created_stack.stack_status).to match /CREATE/
  end

end

