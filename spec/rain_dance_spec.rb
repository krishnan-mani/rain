require_relative '../lib/rain_dance'

RSpec.describe RainDance do
  artifacts_path = File.join(File.dirname(__FILE__), 'dance')

  it 'reads manifest files available' do
    dance = RainDance.new(artifacts_path)
    manifest = dance.list
    expect(manifest["templates"]).to eql(['abc', 'def'])
  end

end