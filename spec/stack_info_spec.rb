require_relative '../lib/stack_info'

RSpec.describe StackInfo do

  it 'determines the type of stack as INDEPENDENT using template metadata' do
    template_path = File.join(File.dirname(__FILE__), 'dance', 'templates', 'abc')
    info = StackInfo.new(template_path)
    expect(info.stack_type).to eql(StackInfo::INDEPENDENT_STACK)
  end

end