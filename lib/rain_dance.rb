require 'yaml'

require_relative 'independent_stack'
require_relative 'context_stack'
require_relative 'environment_stack'
require_relative 'stack_info'

class RainDance

  def initialize(artifacts_path)
    @path = artifacts_path
    load_manifest
  end

  def do_jig!
    stacks = []
    manifest["templates"].each do |template|
      stack = get_stack_instance(File.join(@path, templates_path, template))
      stacks.push(stack)
    end
    stacks.flatten.each { |stack| stack.process! }
  end

  def delete_listed!
    stacks = []
    manifest["templates"].each do |template|
      stack = get_stack_instance(File.join(@path, templates_path, template))
      stacks.push(stack)
    end
    stacks.flatten.reverse!.each { |stack| stack.delete! }
  end

  def get_stack_instance(template_path)
    stack_info = StackInfo.new(template_path)
    if stack_info.independent?
      IndependentStack.new(template_path)
    else

      context_stacks = stack_info.contexts.collect do |context|
        ContextStack.new(template_path, context)
      end

      environment_stacks = stack_info.environments.collect do |environment|
        EnvironmentStack.new(template_path, environment)
      end

      context_stacks.concat(environment_stacks)
    end
  end

  def load_manifest
    @manifest = YAML.load_file(File.join(@path, 'manifest.yml'))
  end

  def manifest
    @manifest.dup
  end

  def templates_path
    manifest["path"]
  end

end