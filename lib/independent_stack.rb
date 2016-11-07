require_relative 'stack'


class IndependentStack
  include Stack

  def initialize(artifacts_folder_path, opts = {})
    @path = artifacts_folder_path
    @options = opts.dup
    get_metadata
    @template = set_template(File.join(@path, 'template.json'))
  end

  def has_contexts?
    not metadata["contexts"].nil?
  end

  def has_environments?
    not metadata["environments"].nil?
  end

  # def contexts
  #   has_contexts? ? metadata["contexts"].keys : nil
  # end
  #
  # def environments
  #   has_environments? ? metadata["environments"].keys : nil
  # end

  def stack_name
    name
  end

  def get_parameters
    get_parameters_from_path(File.join(@path, 'parameters.json'))
  end

end