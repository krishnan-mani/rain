require 'json'


module StackInfoModule

  INDEPENDENT_STACK = 'independent'
  CONTEXT_STACK = 'context'

  def stack_type
    independent? ? INDEPENDENT_STACK : CONTEXT_STACK
  end

  def independent?
    not (has_contexts? or has_environments?)
  end

  def has_contexts?
    not metadata["contexts"].nil?
  end

  def has_environments?
    not metadata["environments"].nil?
  end

  def contexts
    has_contexts? ? metadata["contexts"].keys : nil
  end

  def environments
    has_environments? ? metadata["environments"].keys : nil
  end

  def metadata
    @metadata.dup
  end

  def get_metadata
    metadata_file = File.read(File.join(@path, 'metadata.json'))
    @metadata = JSON.parse(metadata_file)
  end

end