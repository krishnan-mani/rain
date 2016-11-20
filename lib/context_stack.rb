require 'logger'

require_relative 'stack'


class ContextStack
  include Stack

  def initialize(artifacts_folder_path, context_name, opts = {})
    @path = artifacts_folder_path
    @context_name = context_name
    @options = opts.dup
    @logger = @options[:logger] || Logger.new(STDOUT)
    get_metadata
    @template = set_template(File.join(@path, 'template.json'))
  end

  def logger
    @logger
  end

  def region
    metadata["contexts"][@context_name]["region"]
  end

  def on_failure
    metadata["contexts"][@context_name]["onFailure"]
  end

  def action
    metadata["contexts"][@context_name]["action"]
  end

  def stack_name
    "#{name}#{SEPARATOR}context#{SEPARATOR}#{@context_name}#{SEPARATOR}#{region}"
  end

  def get_parameters
    get_parameters_from_path(File.join(@path, 'contexts', @context_name, region, 'parameters.json'))
  end

  def metadata
    @metadata.dup
  end

  def get_metadata
    metadata_file = File.read(File.join(@path, 'metadata.json'))
    @metadata = JSON.parse(metadata_file)
  end
end