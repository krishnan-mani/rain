require_relative '../lib/stack_lifecycle'

base_path = File.dirname(__FILE__)
stack_artifacts_path = File.join(base_path, 'test-stack')
artifacts_region = 'ap-south-1'


require 'securerandom'

def get_artifacts_bucket
  artifacts_bucket = "artifacts-workshop"
  "#{artifacts_bucket}-#{SecureRandom.random_number(10)}"
end

RSpec.describe StackLifecycle do

  my_bucket = get_artifacts_bucket
  options = {"s3Location": my_bucket, "s3Region": artifacts_region}
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

end

RSpec.describe 'it copies stack artifacts' do

  my_bucket = get_artifacts_bucket
  options = {"s3Location": my_bucket, "s3Region": artifacts_region}
  stack = StackLifecycle.new(stack_artifacts_path, 'dev', options)

  s3 = Aws::S3::Client.new(region: artifacts_region)
  before(:each) do
    cleanup(s3, my_bucket)
  end

  after(:each) do
    cleanup(s3, my_bucket)
  end

  it 'copies the stack to a location in S3' do
    expect(stack.metadata["copyToS3"]).to be true
    stack.prepare!

    prefix = "test-stack/dev/ap-south-1/template.json"
    response = s3.list_objects({
                                   bucket: my_bucket,
                                   prefix: prefix
                               })

    first_key = response.contents[0].key
    expect(first_key).to eql prefix
  end
end

RSpec.describe 'it creates stack' do

  my_bucket = get_artifacts_bucket
  options = {"s3Location": my_bucket, "s3Region": artifacts_region}
  stack = StackLifecycle.new(stack_artifacts_path, 'dev', options)

  cf = Aws::CloudFormation::Client.new(region: 'ap-south-1')
  stack_name = 'test-stack-dev-ap-south-1'

  after(:each) do
    cf.delete_stack(stack_name: stack_name)
    cleanup(Aws::S3::Client.new(region: artifacts_region), my_bucket)
  end

  it 'creates the stack' do
    stack.create!
    stack_resource = Aws::CloudFormation::Resource.new(client: cf)
    created_stack = stack_resource.stack(stack_name)
    expect(created_stack.stack_status).to match /CREATE/
  end

end

def cleanup(client, bucket)
  begin
    client.delete_objects({
                              bucket: bucket,
                              delete: {
                                  objects: [
                                      {
                                          key: "test-stack/dev/ap-south-1/template.json", # required
                                      }
                                  ]
                              }
                          })
    client.delete_bucket(bucket: bucket)
  rescue Aws::S3::Errors::ServiceError
  end
end