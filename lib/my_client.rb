require 'aws-sdk'

class MyClient

  def initialize(config)
    @client = Aws::CloudFormation::Client.new(config)
  end

  def exists?(stack_name)
    stack_resource = Aws::CloudFormation::Resource.new(client: @client)
    stack = stack_resource.stack(stack_name)
    stack.exists?
  end

  def method_missing(name, *args)
    @client.send(name, *args)
  end

end