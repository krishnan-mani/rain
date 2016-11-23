require 'logger'

require_relative '../lib/print_module'
require_relative 'stack'


class IndependentStack
  include Stack

  attr_reader :metadata

  def initialize(artifacts_folder_path, opts = {})
    @path = artifacts_folder_path
    @options = opts.dup
    @logger = @options[:logger] || Logger.new(STDOUT)
    read_metadata
    @template = set_template(File.join(@path, 'template.json'))
  end

  def logger
    @logger
  end

  def get_parameters
    get_parameters_from_path(File.join(@path, 'parameters.json'))
  end

  def read_metadata
    metadata_file = File.read(File.join(@path, 'metadata.json'))
    set_metadata(JSON.parse(metadata_file))
  end

  def set_metadata(md)
    @metadata = md.dup
  end

  def generate_parameters_stub
    PrintModule.print_parameters(describe_parameters)
  end

end