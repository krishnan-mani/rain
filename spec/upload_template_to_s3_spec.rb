require_relative '../lib/independent_stack'

RSpec.describe 'creating stacks' do

  my_bucket = get_artifacts_bucket
  artifacts_region = 'ap-south-1'
  options = {"s3Location": my_bucket, "s3Region": artifacts_region}

  base_path = File.dirname(__FILE__)
  stack_name = 'test-stack-s3'
  stack_artifacts_path = File.join(base_path, stack_name)
  stack = IndependentStack.new(stack_artifacts_path, options)

  s3 = Aws::S3::Client.new(region: artifacts_region)
  cf = Aws::CloudFormation::Client.new(region: 'ap-south-1')
  before(:each) do
    cleanup(s3, my_bucket)
    delete_stack(stack_name, cf)
    cf.wait_until(:stack_delete_complete, stack_name: stack_name)
  end

  after(:each) do
    cleanup(s3, my_bucket)
    delete_stack(stack_name, cf)
  end

  it 'copies stack template to a location in S3' do
    expect(stack.metadata["copyToS3"]).to be true
    stack.create!
    cf.wait_until(:stack_create_complete, stack_name: stack_name)

    prefix = "test-stack-s3/template.json"
    response = s3.list_objects({
                                   bucket: my_bucket,
                                   prefix: prefix
                               })

    first_key = response.contents[0].key
    expect(first_key).to eql prefix
  end
end