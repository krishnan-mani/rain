require 'aws-sdk'


class StackLifecycle

  attr_reader :path
  attr_reader :environment

  SEPARATOR = '-'

  def initialize(artifacts_folder_path, environment_name)
    @path = artifacts_folder_path
    @environment = environment_name
    get_metadata
  end

  def name(environment_name)
    base_name = metadata["name"]
    environment = metadata["environments"][environment_name]
    env_region = environment["region"]
    "#{base_name}#{SEPARATOR}#{environment_name}#{SEPARATOR}#{env_region}"
  end

  def metadata
    @metadata.dup
  end

  def exists?
    false
  end

  private

  def get_metadata
    metadata_file = File.read(File.join(@path, 'metadata.json'))
    @metadata = JSON.parse(metadata_file)
  end

end