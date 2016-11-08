require 'yaml'

# require_relative 'independent_stack'
# require_relative 'context_stack'

class RainDance

  def initialize(artifacts_path)
    @path = artifacts_path
  end

  def list
    YAML.load_file(File.join(@path, 'manifest.yml'))
  end

end