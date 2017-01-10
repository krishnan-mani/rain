require_relative '../lib/rain_dance'


base_path = File.dirname(__FILE__)
artifacts_folder = "dance-select"
artifacts_folder_path = File.join(base_path, artifacts_folder)
client = Aws::CloudFormation::Client.new(region: 'ap-south-1')
stack_resource = Aws::CloudFormation::Resource.new(client: client)

RSpec.describe 'process templates by manifest' do

  stack_names = ['test-rain-caruana', 'test-rain-hikaru-context-corus', 'test-rain-hikaru-environment-dev-amber', 'test-rain-hikaru-environment-dev-candidates']

  before(:each) do
    stack_names.each do |stack_name|
      delete_stack(stack_name, client)
      client.wait_until(:stack_delete_complete, stack_name: stack_name)
    end
  end

  it 'creates stacks only for selected environments for a template' do
    dance = RainDance.new(artifacts_folder_path)
    dance.do_jig!

    stack_names.each do |name|
      expect(stack_resource.stack(name).stack_status).to match /CREATE/
    end
  end

end
