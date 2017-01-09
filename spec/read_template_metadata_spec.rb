require_relative '../lib/independent_stack'
require_relative '../lib/stack_info_module'


RSpec.describe 'read template metadata' do

  template_path = File.join(File.dirname(__FILE__), 'dance', 'templates', 'test-rain-abc')
  info = IndependentStack.new(template_path)

  it 'determines the type of stack as INDEPENDENT using template metadata' do
    expect(info.stack_type).to eql(StackInfoModule::INDEPENDENT_STACK)
  end

  it 'constructs a name for the realized stack based on the region' do
    expect(info.name).to eql('test-rain-abc')
  end

end