RSpec.describe 'it copies stack artifacts' do

  my_bucket = get_artifacts_bucket
  artifacts_region = 'ap-south-1'
  options = {"s3Location": my_bucket, "s3Region": artifacts_region}

  base_path = File.dirname(__FILE__)
  stack_artifacts_path = File.join(base_path, 'test-stack-s3')
  stack = StackLifecycle.new(stack_artifacts_path, options)

  s3 = Aws::S3::Client.new(region: artifacts_region)
  before(:each) do
    cleanup(s3, my_bucket)
  end

  after(:each) do
    cleanup(s3, my_bucket)
  end

  it 'copies the stack to a location in S3' do
    expect(stack.metadata["copyToS3"]).to be true
    prefix = "test-stack-s3/template.json"
    response = s3.list_objects({
                                   bucket: my_bucket,
                                   prefix: prefix
                               })

    first_key = response.contents[0].key
    expect(first_key).to eql prefix
  end
end