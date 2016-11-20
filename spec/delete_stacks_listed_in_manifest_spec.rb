require 'aws-sdk'

require_relative '../lib/rain_dance'


artifacts_path = File.join(File.dirname(__FILE__), 'dance-delete')
client = Aws::CloudFormation::Client.new(region: 'ap-south-1')
stack_resource = Aws::CloudFormation::Resource.new(client: client)

RSpec.describe 'process templates by manifest' do

  stack_one, stack_two, stack_three = 'rm-abc', 'rm-def-context-xyz-ap-south-1', 'rm-def-environment-pqr-ap-south-1'
  stack_names = [stack_one, stack_two, stack_three]

  before(:each) do
    stack_names.each do |name|
      delete_stack(name, client)
      client.wait_until(:stack_delete_complete, stack_name: name)
    end
  end

  it 'removes stacks listed' do
    dance = RainDance.new(artifacts_path)
    dance.do_jig!
    stack_names.each do |name|
      _stack = stack_resource.stack(name)
      expect(_stack.stack_status).to match /CREATE/
    end

    dance.delete_listed!

    stack_names.each do |name|
      _stack = stack_resource.stack(name)
      expect(_stack.stack_status).to match /DELETE/
    end
  end

end



