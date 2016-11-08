require 'yaml'

require_relative 'independent_stack'

class RainDance

  def initialize(artifacts_path)
    @path = artifacts_path
    load_manifest
  end

  def do_jig!
    stacks = []
    manifest["templates"].each do |template|
      stacks.push(IndependentStack.new(File.join(@path, templates_path, template)))
    end
    stacks.each { |stack| stack.process! }
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