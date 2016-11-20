require 'aws-sdk'

require_relative '../lib/independent_stack'
require_relative '../lib/rain_dance'


stack_name = 'test-stack-recreate'
artifacts_path = File.join(File.dirname(__FILE__), stack_name)

RSpec.describe "processing templates" do
  client = Aws::CloudFormation::Client.new(region: 'ap-south-1')

  before(:each) do
    delete_stack(stack_name, client)
  end

  it "processes a stack action of 'recreate' by deleting and recreating the stack" do
    stack = IndependentStack.new(artifacts_path)
    stack.create!
    client.wait_until(:stack_create_complete, stack_name: stack_name)

    stack.process!
    stack_resource = Aws::CloudFormation::Resource.new(client: client)
    recreated_stack = stack_resource.stack(stack_name)
    expect(recreated_stack.stack_status).to match /CREATE_/
  end

end