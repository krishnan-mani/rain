require 'aws-sdk'

require_relative '../lib/rain_dance'


artifacts_path = File.join(File.dirname(__FILE__), 'dance-delete')
dance = RainDance.new(artifacts_path)

RSpec.describe 'deleting listed stacks' do

  client = Aws::CloudFormation::Client.new(region: 'ap-south-1')

  stack_one, stack_two, stack_three = 'rm-abc', 'rm-def-context-xyz-ap-south-1', 'rm-def-environment-pqr-ap-south-1'
  stack_names = [stack_one, stack_two, stack_three]

  before(:each) do
    stack_names.each do |name|
      delete_stack(name, client)
    end
  end

  it 'removes stacks in the manifest' do
    dance.do_jig!
    stack_resource = Aws::CloudFormation::Resource.new(client: client)
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



