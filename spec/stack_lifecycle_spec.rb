require_relative '../lib/stack_lifecycle'

RSpec.describe StackLifecycle do

  base_path = File.dirname(__FILE__)
  stack_artifacts_path = File.join(base_path, 'test-stack')

  it 'determines whether a stack exists by the corresponding name in a given region' do
    :pending
  end

  it 'obtains the stack information from metadata' do
    stack = StackLifecycle.new(stack_artifacts_path, 'dev')
    expect(stack.metadata["name"]).to eql('test-stack')
  end

end