require_relative 'stack_info_module'


class StackInfo
  include StackInfoModule

  def initialize(template_path)
    @path = template_path
    get_metadata
  end

end

