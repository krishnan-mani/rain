require 'yaml'

require_relative 'independent_stack'
require_relative 'context_stack'
require_relative 'environment_stack'
require_relative 'stack_info'

class RainDance

  def initialize(artifacts_path, options = {})
    @path = artifacts_path
    @opts = options
    load_manifest
  end

  def do_jig!
    stacks = []
    templates.each do |template|
      stack = get_stack_instance(File.join(@path, templates_path), template, @opts.dup)
      stacks.push(stack)
    end
    stacks.flatten.each { |stack| stack.process! }
  end

  def delete_listed!
    stacks = []
    templates.each do |template|
      stack = get_stack_instance(File.join(@path, templates_path), template)
      stacks.push(stack)
    end
    stacks.flatten.reverse!.each { |stack| stack.delete! }
  end

  def template_name(template_element)
    template_element.is_a?(Hash) ? template_element.keys[0] : template_element
  end

  def get_stack_instance(templates_path, template_element, options = {})
    _name = template_name(template_element)
    template_path = File.join(templates_path, _name)
    stack_info = StackInfo.new(template_path)

    if stack_info.independent?
      IndependentStack.new(template_path, options)
    else
      context_stacks = stack_info.contexts.collect do |context|
        ContextStack.new(template_path, context, options)
      end

      environment_stacks = stack_info.environments.collect do |environment|
        EnvironmentStack.new(template_path, environment, options)
      end

      context_stacks.concat(environment_stacks)
    end
  end

  def load_manifest
    @manifest = YAML.load_file(File.join(@path, 'manifest.yml'))
  end

  def templates
    manifest["templates"].collect do |el|
      el.is_a?(Hash) ? el.keys[0] : el
    end
  end

  def manifest
    @manifest.dup
  end

  def templates_path
    manifest["path"]
  end

end