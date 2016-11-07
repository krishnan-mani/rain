require_relative 'stack'


class ContextStack
  include Stack

  def initialize(artifacts_folder_path, context_name, opts = {})
    @path = artifacts_folder_path
    @context_name = context_name
    @options = opts.dup
    get_metadata
    @template = set_template(File.join(@path, 'template.json'))
  end

  def region
    metadata["contexts"][@context_name]["region"]
  end

  def stack_name
    "#{name}#{SEPARATOR}context#{SEPARATOR}#{@context_name}#{SEPARATOR}#{region}"
  end

  def get_parameters
    get_parameters_from_path(File.join(@path, 'contexts', @context_name, region, 'parameters.json'))
  end

end