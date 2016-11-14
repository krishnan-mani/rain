require 'yaml'

require_relative 'independent_stack'
require_relative 'context_stack'
require_relative 'environment_stack'
require_relative 'stack_info'

class RainDance

  def initialize(artifacts_path, manifest_path = nil, options = {})
    @path = artifacts_path
    @manifest_file_name = manifest_path
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

      contexts_from_manifest = manifest_contexts(template_element)
      selected_contexts = contexts_from_manifest.empty? ? stack_info.contexts : contexts_from_manifest
      context_stacks = selected_contexts.collect do |context|
        ContextStack.new(template_path, context, options)
      end

      environments_from_manifest = manifest_environments(template_element)
      selected_environments = environments_from_manifest.empty? ? stack_info.environments : environments_from_manifest
      environment_stacks = selected_environments.collect do |environment|
        EnvironmentStack.new(template_path, environment, options)
      end

      context_stacks.concat(environment_stacks)
    end
  end

  def manifest_contexts(template_element)
    if template_element.is_a?(Hash)
      template_element.values[0]["contexts"] || []
    else
      []
    end
  end

  def manifest_environments(template_element)
    if template_element.is_a?(Hash)
      template_element.values[0]["environments"] || []
    else
      []
    end
  end

  def load_manifest
    _manifest_path = @manifest_file_name.nil? ? File.join(@path, 'manifest.yml') : File.join(@path, @manifest_file_name)
    @manifest = YAML.load_file(_manifest_path)
  end

  def template_names
    templates.collect do |el|
      el.is_a?(Hash) ? el.keys[0] : el
    end
  end

  def templates
    manifest["templates"]
  end

  def manifest
    @manifest.dup
  end

  def templates_path
    manifest["path"]
  end

end