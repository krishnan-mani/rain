require 'aws-sdk'


require_relative 'rain_errors'
require_relative 'template'


class StackLifecycle

  attr_reader :path

  SEPARATOR = '-'

  def initialize(artifacts_folder_path, environment_name = nil, opts = {})
    @path = artifacts_folder_path

    get_metadata
    @environment = environment_name || metadata["environments"].keys.first
    @options = opts.dup
    template_local_path = File.join(@path, 'template.json')
    @template = set_template(template_local_path)
  end

  def set_template(template_local_path)
    copyToS3? ?
        TemplateInS3.new(template_local_path, @options[:s3Location], @options[:s3Region], template_key) :
        TemplateLocal.new(template_local_path)
  end

  def template_key
    "#{stack_name}/#{@environment}/#{region}/template.json"
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

  def has_parameters?
    metadata["hasParameters"]
  end

  def s3LocationAndRegion
    copyToS3? ? {bucket: @options[:s3Location], region: @options[:s3Region]} : nil
  end

  def exists?
    client = Aws::CloudFormation::Client.new(region: region)
    stack_resource = Aws::CloudFormation::Resource.new(client: client)
    stack = stack_resource.stack(stack_fully_qualified_name)
    stack.exists?
  end

  def list
    client = Aws::CloudFormation::Client.new(region: region)
    response = client.describe_stacks(stack_name: stack_fully_qualified_name)
    response.stacks[0] if (response and response.stacks and (response.stacks.length > 0))
  end

  def process!
    raise RainErrors::StackAlreadyExistsError, "Stack exists: #{stack_fully_qualified_name}" if exists?
    create!
  end


  def create!
    options = {stack_name: stack_fully_qualified_name}

    options.merge!(get_template_element)
    options.merge!("parameters": get_parameters) if has_parameters?

    cf = Aws::CloudFormation::Client.new(region: region)
    stack_resource = Aws::CloudFormation::Resource.new(client: cf)
    stack = stack_resource.create_stack(options)
    stack.wait_until_exists
  end

  def get_template_element;
    @template.get_template_element;
  end

  def get_parameters
    parameters_path = File.join(@path, "environments", @environment, region, 'parameters.json')
    to_parameters_format(JSON.parse(File.read(parameters_path)))
  end

  def to_parameters_format(parameters_from_file)
    parameters_from_file.collect { |el|
      {"parameter_key": el["ParameterKey"], "parameter_value": el["ParameterValue"]}
    }
  end

  private

  def get_metadata
    metadata_file = File.read(File.join(@path, 'metadata.json'))
    @metadata = JSON.parse(metadata_file)
  end

end