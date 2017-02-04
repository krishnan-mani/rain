require 'aws-sdk'

class MyClient

  def initialize(config)
    @client = Aws::CloudFormation::Client.new(region: config[:region])
  end

  def exists?(stack_name)
    stack_resource = Aws::CloudFormation::Resource.new(client: @client)
    stack = stack_resource.stack(stack_name)
    stack.exists?
  end

  def create_stack(options)
    @client.create_stack(options)
  end

end