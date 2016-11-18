require_relative '../lib/rain_dance'


base_path = File.dirname(__FILE__)
artifacts_path = File.join(base_path, 'dance')
dance = RainDance.new(artifacts_path)

RSpec.describe RainDance do

  client = Aws::CloudFormation::Client.new(region: 'ap-south-1')

  stack_names = ['abc', 'def-context-xyz-ap-south-1', 'def-environment-pqr-ap-south-1']

  before(:each) do
    stack_names.each do |name|
      delete_stack(name, client)
    end
  end

  it 'processes a template listed in the manifest' do
    dance.do_jig!
    stack_resource = Aws::CloudFormation::Resource.new(client: client)
    _stack = stack_resource.stack('abc')
    expect(_stack.stack_status).to match /CREATE/

    _stack = stack_resource.stack('def-context-xyz-ap-south-1')
    expect(_stack.stack_status).to match /CREATE/

    _stack = stack_resource.stack('def-environment-pqr-ap-south-1')
    expect(_stack.stack_status).to match /CREATE/
  end

end