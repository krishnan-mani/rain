require 'aws-sdk-cloudformation'

require_relative '../lib/rain_dance'


artifacts_path = File.join(File.dirname(__FILE__), 'dance')
dance = RainDance.new(artifacts_path)

RSpec.describe 'process templates by manifest' do

  it 'lists stacks from manifest files' do
    expect(dance.template_names).to eql(['test-rain-abc', 'test-rain-def'])
  end

  it 'reads the path to stacks' do
    expect(dance.templates_path).to eql('templates')
  end

end

