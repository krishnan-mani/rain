require 'aws-sdk'

require_relative '../lib/rain_dance'


artifacts_path = File.join(File.dirname(__FILE__), 'dance')
dance = RainDance.new(artifacts_path)

RSpec.describe RainDance do

  it 'reads environments specified for stacks in a manifest' do
    manifest = dance.manifest
    expect(manifest["templates"][0]["abc"]["environments"]).to eql(['pqr', 'stu'])
  end

  it 'lists stacks from manifest files' do
    expect(dance.templates).to eql(['abc', 'def'])
  end

  it 'reads the path to stacks' do
    expect(dance.templates_path).to eql('templates')
  end

end

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