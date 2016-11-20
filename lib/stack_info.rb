require_relative 'stack_info_module'


class StackInfo
  include StackInfoModule

  attr_reader :metadata

  def initialize(template_path)
    @path = template_path
    read_metadata
  end

  def read_metadata
    metadata_file = File.read(File.join(@path, 'metadata.json'))
    set_metadata(JSON.parse(metadata_file))
  end

  def set_metadata(md)
    @metadata = md.dup
  end

end

