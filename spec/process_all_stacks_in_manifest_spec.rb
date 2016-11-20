require_relative '../lib/rain_dance'


base_path = File.dirname(__FILE__)
artifacts_path = File.join(base_path, 'dance')
dance = RainDance.new(artifacts_path)
client = Aws::CloudFormation::Client.new(region: 'ap-south-1')
stack_resource = Aws::CloudFormation::Resource.new(client: client)

RSpec.describe 'process templates by manifest' do

  stack_names = ['abc', 'def-context-xyz-ap-south-1', 'def-environment-pqr-ap-south-1']

  before(:each) do
    stack_names.each do |name|
      delete_stack(name, client)
      client.wait_until(:stack_delete_complete, stack_name: name)
    end
  end

  it 'creates stacks listed' do
    dance.do_jig!

    stack_names.each do |name|
      _stack = stack_resource.stack(name)
      expect(_stack.stack_status).to match /CREATE/
    end
  end

end