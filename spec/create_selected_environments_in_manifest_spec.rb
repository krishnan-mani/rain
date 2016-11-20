require_relative '../lib/rain_dance'


base_path = File.dirname(__FILE__)
artifacts_folder = "dance-select"
artifacts_folder_path = File.join(base_path, artifacts_folder)
client = Aws::CloudFormation::Client.new(region: 'ap-south-1')

RSpec.describe 'processing templates by manifest' do

  stack_names = ['caruana', 'hikaru-context-corus-ap-south-1', 'hikaru-environment-dev-amber-ap-south-1', 'hikaru-environment-dev-candidates-ap-south-1']

  before(:each) do
    stack_names.each do |stack_name|
      delete_stack(stack_name, client)
    end
  end

  it 'creates stacks only for selected environments for a template' do
    dance = RainDance.new(artifacts_folder_path)
    dance.do_jig!

    stack_resource = Aws::CloudFormation::Resource.new(client: client)
    stack_names.each do |name|
      expect(stack_resource.stack(name).stack_status).to match /CREATE/
    end
  end

end
