require_relative '../lib/independent_stack'


base_path = File.dirname(__FILE__)
stack_name = 'test-stack-generate-parameters-stub'
artifacts_path = File.join(base_path, stack_name)

describe "read a template" do

  it 'generates a stub file containing the required parameters' do
    stack = IndependentStack.new(artifacts_path)
    response = stack.generate_parameters_stub
    expect(response.first).to match /VersioningStatus/
    expect(response.last).to match /bar/
  end

end