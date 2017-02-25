require 'logger'

require_relative 'stack'


class EnvironmentStack
  include Stack

  attr_reader :metadata

  def initialize(artifacts_folder_path, environment_name, opts = {})
    @path = artifacts_folder_path
    @environment_name = environment_name
    @options = opts.dup
    @logger = @options[:logger] || Logger.new(STDOUT)
    read_metadata
    @template = set_template(File.join(@path, 'template.json'))
  end

  def client(config)
    MyClient.new(config)
  end

  def logger
    @logger
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
    "#{name}#{SEPARATOR}environment#{SEPARATOR}#{@environment_name}"
  end

  def get_parameters
    get_parameters_from_path(File.join(@path, 'environments', @environment_name, region, 'parameters.json'))
  end

  def read_metadata
    metadata_file = File.read(File.join(@path, 'metadata.json'))
    set_metadata(JSON.parse(metadata_file))
  end

  def set_metadata(md)
    @metadata = md.dup
  end
end