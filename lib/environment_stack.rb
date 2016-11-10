require_relative 'stack'


class EnvironmentStack
  include Stack

  def initialize(artifacts_folder_path, environment_name, opts = {})
    @path = artifacts_folder_path
    @environment_name = environment_name
    @options = opts.dup
    get_metadata
    @template = set_template(File.join(@path, 'template.json'))
  end

  def region
    metadata["environments"][@environment_name]["region"]
  end

  def on_failure
    metadata["environments"][@environment_name]["onFailure"]
  end

  def action
    metadata["environments"][@environment_name]["action"]
  end

  def stack_name
    "#{name}#{SEPARATOR}environment#{SEPARATOR}#{@environment_name}#{SEPARATOR}#{region}"
  end

  def get_parameters
    get_parameters_from_path(File.join(@path, 'environments', @environment_name, region, 'parameters.json'))
  end

end