require_relative '../lib/rain_dance'


RSpec.describe RainDance do

  base_path = File.dirname(__FILE__)
  stack_name = "dance-select"
  artifacts_folder_path = File.join(base_path, stack_name)

  # client = Aws::CloudFormation::Client.new(region: 'ap-south-1')

  it 'processes only selected environments for a template as specified in the manifest' do
    dance = RainDance.new(artifacts_folder_path)
    dance.do_jig!

    # verify which stacks were created

  end

end
