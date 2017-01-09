require_relative '../lib/independent_stack'
require_relative '../lib/rain_dance'


base_path = File.dirname(__FILE__)
artifacts_path = File.join(base_path, 'test-stack-change-set')
client = Aws::CloudFormation::Client.new(region: 'ap-south-1')

RSpec.describe 'process a template' do

  stack_name = 'test-stack-change-set'
  before(:each) do
    delete_stack(stack_name, client)
    client.wait_until(:stack_delete_complete, stack_name: stack_name)

    FileUtils.copy(File.join(artifacts_path, 'original-template.json'), File.join(artifacts_path, 'template.json'))
  end

  it 'lists any pending change-set' do
    stack = IndependentStack.new(artifacts_path)
    stack.process!
    client.wait_until(:stack_create_complete, stack_name: stack_name)

    FileUtils.copy(File.join(artifacts_path, 'updated-template.json'), File.join(artifacts_path, 'template.json'))
    stack.process!

    client.wait_until(:change_set_create_complete, stack_name: stack_name)

    client_response = client.list_change_sets(stack_name: stack_name)
    expect(client_response.summaries.length).to eql 1
    listed_status = client_response.summaries[0].status
    expect(listed_status).to match /CREATE/

    change_set_summaries = stack.list_change_sets
    expect(change_set_summaries.length).to eql 1
    expect(change_set_summaries[0].status).to eql(listed_status)
  end

  after(:each) do
    FileUtils.copy(File.join(artifacts_path, 'original-template.json'), File.join(artifacts_path, 'template.json'))
  end
end