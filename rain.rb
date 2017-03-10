#!/usr/bin/env ruby
require 'optparse'

require_relative 'lib/rain_dance'

options = {}
OptionParser.new do |opts|
  opts.banner = "Usage: rain.rb [options]"

  opts.on('-p', '--path PATH', '(REQUIRED) Specify a filesystem path to the template artifacts') do |path|
    options[:artifacts_path] = path
  end

  opts.on('-f', '--file manifest-file', 'Specify a manifest file') do |file|
    options[:manifest_file] = file
  end

  opts.on('-b', '--s3-bucket bucket', 'Specify an S3 bucket and S3 region') do |bucket|
    options[:s3_bucket] = bucket
  end

  opts.on('-r', '--s3-region region', 'Specify an S3 bucket and S3 region') do |region|
    options[:s3_region] = region
  end

  opts.on('-h', '--help', 'Display help') do
    puts opts
    exit
  end
end.parse!

raise OptionParser::MissingArgument, "-p /path/to/template/artifacts" if options[:artifacts_path].nil?

artifacts_path = options[:artifacts_path]
manifest_file_name = options[:manifest_file]
app_options = {s3Location: options[:s3_bucket], s3Region: options[:s3_region]}

dance = RainDance.new(artifacts_path, manifest_file_name, app_options)
dance.do_jig!
