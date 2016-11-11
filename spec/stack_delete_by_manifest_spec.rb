require 'aws-sdk'

require_relative '../lib/rain_dance'


artifacts_path = File.join(File.dirname(__FILE__), 'dance-delete')
dance = RainDance.new(artifacts_path)

RSpec.describe RainDance do

  client = Aws::CloudFormation::Client.new(region: 'ap-south-1')

  before(:each) do
    delete_stack('abc', client)
    delete_stack('def-context-xyz-ap-south-1', client)
    delete_stack('def-environment-pqr-ap-south-1', client)
  end

  after(:each) do
    delete_stack('abc', client)
    delete_stack('def-context-xyz-ap-south-1', client)
    delete_stack('def-environment-pqr-ap-south-1', client)
  end

  it 'deletes stacks for all listed in the manifest (in the reverse order)' do
    dance.do_jig!
    stack_resource = Aws::CloudFormation::Resource.new(client: client)
    _stack = stack_resource.stack('abc')
    expect(_stack.stack_status).to match /CREATE/

    _stack = stack_resource.stack('def-context-xyz-ap-south-1')
    expect(_stack.stack_status).to match /CREATE/

    _stack = stack_resource.stack('def-environment-pqr-ap-south-1')
    expect(_stack.stack_status).to match /CREATE/

    dance.delete_listed!

    _stack = stack_resource.stack('def-environment-pqr-ap-south-1')
    expect(_stack.stack_status).to match /DELETE/

    _stack = stack_resource.stack('def-context-xyz-ap-south-1')
    expect(_stack.stack_status).to match /DELETE/

    _stack = stack_resource.stack('abc')
    expect(_stack.stack_status).to match /DELETE/
  end

end



