require_relative '../lib/rain_dance'


RSpec.describe 'process listed stacks' do

  base_path = File.dirname(__FILE__)
  artifacts_folder = "dance-select"
  artifacts_folder_path = File.join(base_path, artifacts_folder)

  client = Aws::CloudFormation::Client.new(region: 'ap-south-1')

  stacks = ['caruana', 'hikaru-context-corus-ap-south-1', 'hikaru-environment-dev-amber-ap-south-1', 'hikaru-environment-dev-candidates-ap-south-1']

  before(:each) do
    stacks.each do |stack_name|
      delete_stack(stack_name, client)
    end
  end

  after(:each) do
    stacks.each do |stack_name|
      # delete_stack(stack_name, client)
    end
  end

  it 'processes only selected environments for a template as specified in the manifest' do
    dance = RainDance.new(artifacts_folder_path)
    dance.do_jig!

    stack_resource = Aws::CloudFormation::Resource.new(client: client)

    expect(stack_resource.stack('caruana').stack_status).to match /CREATE/
    expect(stack_resource.stack('hikaru-context-corus-ap-south-1').stack_status).to match /CREATE/
    expect(stack_resource.stack('hikaru-environment-dev-amber-ap-south-1').stack_status).to match /CREATE/
    expect(stack_resource.stack('hikaru-environment-dev-candidates-ap-south-1').stack_status).to match /CREATE/

  end

end
