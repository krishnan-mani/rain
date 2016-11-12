require 'aws-sdk'

require_relative '../lib/independent_stack'


base_path = File.dirname(__FILE__)
stack_name = 'test-stack-update-policy'
stack_path = File.join(base_path, stack_name)
stack = IndependentStack.new(stack_path)

RSpec.describe IndependentStack do
  client = Aws::CloudFormation::Client.new(region: 'ap-south-1')

  before(:each) do
    delete_stack(stack_name, client)
    client.wait_until(:stack_delete_complete, stack_name: stack_name)

    template_path = File.join(stack_path, 'template.json')
    FileUtils.remove(File.join(template_path)) if FileTest.exist?(template_path)
  end

  after(:each) do
    FileUtils.remove(File.join(stack_path, 'template.json'))
  end

  it 'throws an error if a stack update policy prevents updates' do
    FileUtils.copy(File.join(stack_path, 'original-template.json'), File.join(stack_path, 'template.json'))
    stack.create!
    client.wait_until(:stack_create_complete, stack_name: stack_name)

    FileUtils.copy(File.join(stack_path, 'updated-template.json'), File.join(stack_path, 'template.json'))
    stack.update!
  end

end