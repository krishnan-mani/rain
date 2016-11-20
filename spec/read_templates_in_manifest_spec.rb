require 'aws-sdk'

require_relative '../lib/rain_dance'


artifacts_path = File.join(File.dirname(__FILE__), 'dance')
dance = RainDance.new(artifacts_path)

RSpec.describe 'processing templates by manifest' do

  it 'lists stacks from manifest files' do
    expect(dance.template_names).to eql(['abc', 'def'])
  end

  it 'reads the path to stacks' do
    expect(dance.templates_path).to eql('templates')
  end

end

