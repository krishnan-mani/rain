require 'aws-sdk'

require_relative '../lib/independent_stack'


RSpec.describe "updating stacks" do

  base_path = File.dirname(__FILE__)
  stack_name = 'test-stack-create'
  stack_path = File.join(base_path, stack_name)
  client = Aws::CloudFormation::Client.new(region: 'ap-south-1')
  stack = IndependentStack.new(stack_path)

  before(:each) do
    delete_stack(stack_name, client)
    client.wait_until(:stack_delete_complete, stack_name: stack_name)
  end

  it 'reports an error when an update is attempted without any changes' do
    stack.create!
    client.wait_until(:stack_create_complete, stack_name: stack_name)
    expect { stack.update! }.to raise_error(RainErrors::NoUpdatesToStackError, "No updates are to be performed.")
  end

end