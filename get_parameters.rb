#!/usr/bin/env ruby

require_relative 'lib/independent_stack'
require 'optparse'


options = {}
OptionParser.new do |opts|
  opts.banner = "Usage: get_parameters.rb [options]"

  opts.on('-p', '--path PATH', '(REQUIRED) Specify a filesystem path (the directory containing template.json') do |path|
    options[:artifacts_path] = path
  end

  opts.on('-h', '--help', 'Display help') do
    puts opts
    exit
  end
end.parse!

raise OptionParser::MissingArgument, "-p /path/to/template" if options[:artifacts_path].nil?

artifacts_path = options[:artifacts_path]
puts IndependentStack.new(artifacts_path).generate_parameters_stub
