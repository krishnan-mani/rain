require 'aws-sdk'

require_relative '../lib/rain_dance'


artifacts_path = File.join(File.dirname(__FILE__), 'dance')
dance = RainDance.new(artifacts_path)

RSpec.describe RainDance do

  it 'reads manifest files available' do
    manifest = dance.manifest
    expect(manifest["templates"]).to eql(['abc', 'def'])
  end

  it 'reads the path to stacks' do
    expect(dance.templates_path).to eql('templates')
  end

end

RSpec.describe RainDance do

  client = Aws::CloudFormation::Client.new(region: 'ap-south-1')

  before(:each) do
    delete_stack('abc', client)
  end

  after(:each) do
    delete_stack('abc', client)
  end

  it 'processes a template listed in the manifest' do
    dance.do_jig!
    stack_resource = Aws::CloudFormation::Resource.new(client: client)
    created_stack = stack_resource.stack('abc')
    expect(created_stack.stack_status).to match /CREATE/
  end

end