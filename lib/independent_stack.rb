require 'logger'

require_relative 'stack'


class IndependentStack
  include Stack

  def initialize(artifacts_folder_path, opts = {})
    @path = artifacts_folder_path
    @options = opts.dup
    @logger = @options[:logger] || Logger.new(STDOUT)
    get_metadata
    @template = set_template(File.join(@path, 'template.json'))
  end

  def logger
    @logger
  end

  def stack_name
    name
  end

  def get_parameters
    get_parameters_from_path(File.join(@path, 'parameters.json'))
  end

  def metadata
    @metadata.dup
  end

  def get_metadata
    metadata_file = File.read(File.join(@path, 'metadata.json'))
    @metadata = JSON.parse(metadata_file)
  end

end