require_relative '../lib/rain_dance'


RSpec.describe RainDance do

  base_path = File.dirname(__FILE__)
  artifacts_folder = "dance-select"
  artifacts_folder_path = File.join(base_path, artifacts_folder)

  client = Aws::CloudFormation::Client.new(region: 'ap-south-1')

  before(:each) do
    ['abc-ap-south-1', 'def-context-karjakin-ap-south-1', 'def-environment-pqr-ap-south-1', 'def-environment-stu-ap-south-1', 'def-environment-jkl-ap-south-1'].each do |stack_name|
      delete_stack(stack_name, client)
    end
  end

  after(:each) do
    ['abc-ap-south-1', 'def-context-karjakin-ap-south-1', 'def-environment-pqr-ap-south-1', 'def-environment-stu-ap-south-1', 'def-environment-jkl-ap-south-1'].each do |stack_name|
      delete_stack(stack_name, client)
    end
  end

  it 'processes only selected environments for a template as specified in the manifest' do
    dance = RainDance.new(artifacts_folder_path)
    dance.do_jig!

    stack_resource = Aws::CloudFormation::Resource.new(client: client)

    _stack = stack_resource.stack('abc-ap-south-1')
    expect(_stack.stack_status).to match /CREATE/

    _stack = stack_resource.stack('def-context-karjakin-ap-south-1')
    expect(_stack.stack_status).to match /CREATE/

    _stack = stack_resource.stack('def-environment-pqr-ap-south-1')
    expect(_stack.stack_status).to match /CREATE/

    _stack = stack_resource.stack('def-environment-stu-ap-south-1')
    expect(_stack.stack_status).to match /CREATE/

    _stack = stack_resource.stack('def-environment-jkl-ap-south-1')
    expect(stack.exists?).to be false

    _stack = stack_resource.stack('def-context-xyz-ap-south-1')
    expect(stack.exists?).to be false

  end

end
