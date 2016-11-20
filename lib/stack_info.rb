require_relative 'stack_info_module'


class StackInfo
  include StackInfoModule

  def initialize(template_path)
    @path = template_path
    get_metadata
  end

  def metadata
    @metadata.dup
  end

  def get_metadata
    metadata_file = File.read(File.join(@path, 'metadata.json'))
    @metadata = JSON.parse(metadata_file)
  end
  
end

