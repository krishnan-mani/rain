require 'aws-sdk'


class StackLifecycle

  attr_reader :path
  attr_reader :environment

  def initialize(artifacts_folder_path, environment_name)
    @path = artifacts_folder_path
    @environment = environment_name
    get_metadata
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