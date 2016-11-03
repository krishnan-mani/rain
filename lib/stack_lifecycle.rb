require 'aws-sdk'


class StackLifecycle

  attr_reader :path
  attr_reader :environment

  SEPARATOR = '-'

  def initialize(artifacts_folder_path, environment_name, opts = {})
    @path = artifacts_folder_path
    @environment = environment_name
    get_metadata
    @options = opts.dup
  end

  def name(environment_name)
    base_name = metadata["name"]
    environment = metadata["environments"][environment_name]
    env_region = environment["region"]
    "#{base_name}#{SEPARATOR}#{environment_name}#{SEPARATOR}#{env_region}"
  end

  def stack_fully_qualified_name
    name(@environment)
  end

  def stack_name
    metadata["name"]
  end

  def region
    metadata["environments"][@environment]["region"]
  end

  def metadata
    @metadata.dup
  end

  def copyToS3?
    @metadata["copyToS3"]
  end

  def s3LocationAndRegion
    copyToS3? ? {bucket: @options[:s3Location], region: @options[:s3Region]} : nil
  end

  def prepare!
    if !(s3LocationAndRegion.nil?)
      bucket, region = s3LocationAndRegion[:bucket], s3LocationAndRegion[:region]

      s3 = Aws::S3::Client.new(region: region)
      begin
        s3.head_bucket({
                           bucket: bucket
                       })
      rescue Aws::S3::Errors::ServiceError
        s3.create_bucket({bucket: bucket})
      end

      key = "#{stack_name}/#{@environment}/#{metadata["environments"][@environment]["region"]}/template.json"
      template_path = File.join(@path, 'template.json')
      File.open(template_path, 'rb') do |file|
        s3.put_object(
            bucket: s3LocationAndRegion[:bucket],
            key: key,
            body: file
        )
      end
      "https://s3.amazonaws.com/#{bucket}/#{key}"
    end
  end

  def create!
    cf = Aws::CloudFormation::Client.new(region: region)
    stack_resource = Aws::CloudFormation::Resource.new(client: cf)
    template_url = prepare!
    stack = stack_resource.create_stack({
                                            stack_name: stack_fully_qualified_name,
                                            template_url: template_url
                                        })
    stack.wait_until_exists
  end

  private

  def get_metadata
    metadata_file = File.read(File.join(@path, 'metadata.json'))
    @metadata = JSON.parse(metadata_file)
  end

end