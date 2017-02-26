require 'aws-sdk'

require_relative 'template'
require_relative 'rain_errors'
require_relative 'stack_info_module'


module Stack

  def self.included klass
    klass.class_eval do
      include StackInfoModule
    end
  end

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
    client(region: region).exists?(stack_name)
  end

  def action
    metadata["action"]
  end

  def on_failure
    metadata["onFailure"]
  end

  def process!
    case action
      when CREATE_ACTION
        create_action!
      when UPDATE_ACTION
        update_action!
      when RECREATE_ACTION
        recreate_action!
      else
        raise RainErrors::StackActionNotSupportedError, "Action: #{action}"
    end
  end

  def recreate_action!
    if exists?
      delete!
      client(region: region).wait_until(:stack_delete_complete, stack_name: stack_name)
    end
    create!
    client(region: region).wait_until(:stack_create_complete, stack_name: stack_name)
  end

  def create_action!
    if exists?
      create_change_set
    else
      create!
      client(region: region).wait_until(:stack_create_complete, stack_name: stack_name)
    end
  end

  def update_action!
    if exists?
      update!
      client(region: region).wait_until(:stack_update_complete, stack_name: stack_name)
    else
      create!
      client(region: region).wait_until(:stack_create_complete, stack_name: stack_name)
    end
  end

  def logger
    raise "instances to implement #logger"
  end

  def delete!
    logger.info "Deleting stack #{stack_name}"
    client(region: region).delete_stack(stack_name: stack_name)
  end

  def list_change_sets
    logger.info "Retrieving change sets for #{stack_name}"
    client(region: region).list_change_sets(stack_name: stack_name).summaries
  end

  def update!
    options = {stack_name: stack_name}
    options.merge!(get_template_element)
    options.merge!("parameters": get_parameters) if has_parameters?
    options.merge!("capabilities": capabilities)

    logger.info "Updating stack #{stack_name}"
    client(region: region).update_stack(options)
  end

  def change_set_name
    "D#{Time.new.strftime("%Y%m%dT%H%M%S%z").gsub('+', '-')}"
  end

  def create_change_set
    options = {stack_name: stack_name}
    options.merge!(get_template_element)
    options.merge!("parameters": get_parameters) if has_parameters?
    options.merge!("capabilities": capabilities)

    _change_set_name = change_set_name
    options.merge!(change_set_name: _change_set_name)

    logger.info "Creating change set #{_change_set_name} against stack #{stack_name}"
    client(region: region).create_change_set(options)
  end

  def create!
    options = {stack_name: stack_name}
    options.merge!(get_template_element)
    options.merge!("parameters": get_parameters) if has_parameters?
    options.merge!("capabilities": capabilities)
    options.merge!(get_stack_policy_element)
    options.merge!(on_failure: on_failure) if on_failure

    logger.info "Creating stack #{stack_name}"
    client(region: region).create_stack(options)
  end

  def template_key
    "#{stack_name}/template.json"
  end

  def get_stack_policy_element
    update_policy_path = File.join(@path, 'update-policy.json')
    if FileTest.exist?(update_policy_path)
      {stack_policy_body: File.read(update_policy_path).to_s}
    else
      {}
    end
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

  def describe_parameters
    response = client(region: region).validate_template(get_template_element)
    response.parameters
  end

  def capabilities
    metadata["capabilities"]
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

  def stack_name
    name
  end

  def has_parameters?
    metadata["hasParameters"]
  end

  def client(config)
    raise "instances to implement #client(config)"
  end

end

