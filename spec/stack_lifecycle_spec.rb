require_relative '../lib/stack_lifecycle'

base_path = File.dirname(__FILE__)
stack_artifacts_path = File.join(base_path, 'test-stack')

RSpec.describe StackLifecycle do

  stack = StackLifecycle.new(stack_artifacts_path, 'dev')

  it 'obtains the stack information from metadata' do
    expect(stack.metadata["name"]).to eql('test-stack')
  end

  it 'determines any restrictions on use of AWS regions for the stack' do
    regions = stack.metadata["regions"]
    expect(regions.length).to eql 2
    expect(regions.include?("us-east-1")).to be true
    expect(regions.include?("ap-south-1")).to be true
  end

  it 'determines any environments and a supported region and action for the environment' do
    environments = stack.metadata["environments"]
    expect(environments["dev"]).not_to be nil
    expect(environments["dev"]["region"]).to eql('ap-south-1')
    expect(environments["dev"]["action"]).to eql('create')
  end

  it 'constructs a name for the realized stack based on the environment and region' do
    expect(stack.name("dev")).to eql('test-stack-dev-ap-south-1')
  end

end


RSpec.describe 'it creates stack' do

  stack = StackLifecycle.new(stack_artifacts_path, 'dev')

  cf = Aws::CloudFormation::Client.new(region: 'ap-south-1')
  stack_name = 'test-stack-dev-ap-south-1'

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

