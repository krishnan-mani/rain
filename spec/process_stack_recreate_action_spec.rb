require 'aws-sdk-cloudformation'

require_relative '../lib/independent_stack'
require_relative '../lib/rain_dance'


stack_name = 'test-stack-recreate'
artifacts_path = File.join(File.dirname(__FILE__), stack_name)
client = Aws::CloudFormation::Client.new(region: 'ap-south-1')
stack_resource = Aws::CloudFormation::Resource.new(client: client)

RSpec.describe "process a template" do

  before(:each) do
    delete_stack(stack_name, client)
    client.wait_until(:stack_delete_complete, stack_name: stack_name)
  end

  it "deletes and creates the stack for a stack action of 'recreate'" do
    stack = IndependentStack.new(artifacts_path)
    stack.create!
    client.wait_until(:stack_create_complete, stack_name: stack_name)

    stack.process!
    recreated_stack = stack_resource.stack(stack_name)
    expect(recreated_stack.stack_status).to match /CREATE_/
  end

end
