require 'aws-sdk'

require_relative 'template'
require_relative 'rain_errors'


module Stack

  CREATE_ACTION = 'create'
  UPDATE_ACTION = 'update'
  RECREATE_ACTION = 'recreate'

  STACK_ACTIONS = [CREATE_ACTION, UPDATE_ACTION, RECREATE_ACTION]

  SEPARATOR = '-'

  def set_template(template_local_path)
    copyToS3? ?
        TemplateInS3.new(template_local_path, @options[:s3Location], @options[:s3Region], template_key) :
        TemplateLocal.new(template_local_path)
  end

  def exists?
    client = Aws::CloudFormation::Client.new(region: region)
    stack_resource = Aws::CloudFormation::Resource.new(client: client)
    stack = stack_resource.stack(stack_name)
    stack.exists?
  end

  def action
    metadata["action"]
  end

  def process!
    case action
      when CREATE_ACTION
        create_action!
      when UPDATE_ACTION
        update_action!
      else
        raise RainErrors::StackActionNotSupportedError, "Action: #{action}"
    end
  end

  def create_action!
    exists? ? create_change_set : create!
  end

  def update_action!
    exists? ? update! : create!
  end

  def update!
    options = {stack_name: stack_name}
    options.merge!(get_template_element)
    options.merge!("parameters": get_parameters) if has_parameters?
    options.merge!("capabilities": get_capabilities)

    cf = Aws::CloudFormation::Client.new(region: region)
    cf.update_stack(options)
  end

  def change_set_name
    "D#{Time.new.strftime("%Y%m%dT%H%M%S%z").gsub('+', '-')}"
  end

  def create_change_set
    options = {stack_name: stack_name}
    options.merge!(get_template_element)
    options.merge!("parameters": get_parameters) if has_parameters?
    options.merge!("capabilities": get_capabilities)
    options.merge!(change_set_name: change_set_name)

    cf = Aws::CloudFormation::Client.new(region: region)
    cf.create_change_set(options)
  end

  def create!
    options = {stack_name: stack_name}
    options.merge!(get_template_element)
    options.merge!("parameters": get_parameters) if has_parameters?
    options.merge!("capabilities": get_capabilities)

    cf = Aws::CloudFormation::Client.new(region: region)
    stack_resource = Aws::CloudFormation::Resource.new(client: cf)
    stack = stack_resource.create_stack(options)
    stack.wait_until_exists
  end

  def template_key
    "#{stack_name}/template.json"
  end

  def get_template_element
    @template.get_template_element
  end

  def get_parameters_from_path(path_to_parameters = nil)
    path = path_to_parameters || File.join(@path, 'parameters.json')
    to_parameters_format(JSON.parse(File.read(path)))
  end

  def to_parameters_format(parameters_from_file)
    parameters_from_file.collect { |el|
      {"parameter_key": el["ParameterKey"], "parameter_value": el["ParameterValue"]}
    }
  end

  def get_capabilities
    client = Aws::CloudFormation::Client.new(region: region)
    response = client.validate_template(get_template_element)
    response.capabilities
  end

  def metadata
    @metadata.dup
  end

  def region
    metadata["region"]
  end

  def copyToS3?
    metadata["copyToS3"]
  end

  def name
    metadata["name"]
  end

  def has_parameters?
    metadata["hasParameters"]
  end

  def get_metadata
    metadata_file = File.read(File.join(@path, 'metadata.json'))
    @metadata = JSON.parse(metadata_file)
  end

end

