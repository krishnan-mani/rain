require 'yaml'

require_relative 'independent_stack'
require_relative 'context_stack'
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

  def get_stack_instance(template_path)
    stack_info = StackInfo.new(template_path)
    if stack_info.independent?
      IndependentStack.new(template_path)
    else
      stack_info.contexts.collect do |context|
        ContextStack.new(template_path, context)
      end
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