require 'aws-sdk'

require_relative 'rain_errors'
require_relative 'template'


class StackLifecycle

  attr_reader :path

  SEPARATOR = '-'

  def initialize(artifacts_folder_path, opts = {})
    @path = artifacts_folder_path
    @options = opts.dup
    get_metadata
    @template = set_template(File.join(@path, 'template.json'))
  end

  def set_template(template_local_path)
    copyToS3? ?
        TemplateInS3.new(template_local_path, @options[:s3Location], @options[:s3Region], template_key) :
        TemplateLocal.new(template_local_path)
  end

  def template_key
    "#{stack_name}/template.json"
  end

  def context_free?
    not (has_contexts? or has_environments?)
  end

  def has_contexts?
    not metadata["contexts"].nil?
  end

  def has_environments?
    not metadata["environments"].nil?
  end

  def contexts
    has_contexts? ? metadata["contexts"].keys : nil
  end

  def environments
    has_environments? ? metadata["environments"].keys : nil
  end

  def stack_name
    metadata["name"]
  end

  def name
    metadata["name"]
  end

  def stack_name_for_context(context_name)
    "#{name}-context-#{context_name}-#{region_for_context(context_name)}"
  end

  def metadata
    @metadata.dup
  end

  def copyToS3?
    metadata["copyToS3"]
  end

  def context_free_region
    context_free? ? (region.nil? ? "ap-south-1" : region) : nil
  end

  def region
    metadata["region"]
  end

  def region_for_context(context_name)
    metadata["contexts"][context_name]["region"]
  end

  def has_parameters?
    metadata["hasParameters"]
  end

  def exists?
    client = Aws::CloudFormation::Client.new(region: context_free_region)
    stack_resource = Aws::CloudFormation::Resource.new(client: client)
    stack = stack_resource.stack(stack_name)
    stack.exists?
  end

  def exists_for_context_name?(context_name)
    client = Aws::CloudFormation::Client.new(region: region_for_context(context_name))
    stack_resource = Aws::CloudFormation::Resource.new(client: client)
    stack = stack_resource.stack(stack_name_for_context(context_name))
    stack.exists?
  end

  def process_for_context(context_name)
    raise RainErrors::StackAlreadyExistsError, "Stack exists: #{stack_name_for_context(context_name)}" if exists_for_context_name?(context_name)
    create_for_context(context_name)
  end

  def create_for_context(context_name)
    options = {stack_name: stack_name_for_context(context_name)}
    options.merge!(get_template_element)
    options.merge!("parameters": get_parameters_for_context(context_name)) if has_parameters?

    cf = Aws::CloudFormation::Client.new(region: region_for_context(context_name))
    stack_resource = Aws::CloudFormation::Resource.new(client: cf)
    stack = stack_resource.create_stack(options)
    stack.wait_until_exists
  end

  def process!
    raise RainErrors::StackAlreadyExistsError, "Stack exists: #{stack_name}" if exists?
    create!
  end

  def create!
    options = {stack_name: stack_name}

    options.merge!(get_template_element)
    options.merge!("parameters": get_parameters) if has_parameters?

    cf = Aws::CloudFormation::Client.new(region: context_free_region)
    stack_resource = Aws::CloudFormation::Resource.new(client: cf)
    stack = stack_resource.create_stack(options)
    stack.wait_until_exists
  end

  def get_template_element
    @template.get_template_element
  end

  def get_parameters_for_context(context_name)
    parameters_path = File.join(@path, "contexts", context_name, region_for_context(context_name), 'parameters.json')
    to_parameters_format(JSON.parse(File.read(parameters_path)))
  end

  def get_parameters
    parameters_path = File.join(@path, 'parameters.json')
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