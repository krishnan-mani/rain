require_relative '../lib/stack_lifecycle'


RSpec.describe StackLifecycle do

  base_path = File.dirname(__FILE__)
  stack_artifacts_path = File.join(base_path, 'test-stack')
  artifacts_bucket = "artifacts-workshop-213"
  artifacts_region = 'ap-south-1'
  options = {"s3Location": artifacts_bucket, "s3Region": artifacts_region}
  stack = StackLifecycle.new(stack_artifacts_path, 'dev', options)

  it 'determines whether a stack exists by the corresponding name in a given region' do
    :pending
  end

  it 'obtains the stack information from metadata' do
    expect(stack.metadata["name"]).to eql('test-stack')
  end

  it 'determines any restrictions on use of AWS regions for the stack' do
    regions = stack.metadata["regions"]
    expect(regions.length).to eql 2
    expect(regions.include?("us-east-1")).to be true
    expect(regions.include?("ap-south-1")).to be true
  end

  it 'determines any environments and a supported region and action for the environment' do
    environments = stack.metadata["environments"]
    expect(environments["dev"]).not_to be nil
    expect(environments["dev"]["region"]).to eql('ap-south-1')
    expect(environments["dev"]["action"]).to eql('recreate')
  end

  it 'constructs a name for the realized stack based on the environment and region' do
    expect(stack.name("dev")).to eql('test-stack-dev-ap-south-1')
  end

  it 'copies the stack to a location in S3' do
    expect(stack.metadata["copyToS3"]).to be true
    stack.prepare!

    s3 = Aws::S3::Client.new(region: artifacts_region)
    prefix = "test-stack-dev-ap-south-1/template.json"
    response = s3.list_objects({
                                   bucket: artifacts_bucket,
                                   prefix: prefix
                               })

    first_key = response.contents[0].key
    expect(first_key).to eql('test-stack-dev-ap-south-1/template.json')
  end

end