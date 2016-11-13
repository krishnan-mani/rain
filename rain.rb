#!/usr/bin/env ruby

require 'optparse'

options = {}

parser = OptionParser.new do |opts|
  opts.banner = "Usage: rain.rb [options]"

  opts.on('-p', '--path path', 'Specify a filesystem path to the template artifacts') do |path|
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

end

parser.parse!

manifest_path = options[:manifest_file] || File.join(options[:artifacts_path], 'manifest.yml')
raise ArgumentError, "missing manifest path or manifest file" unless FileTest.exist?(manifest_path)

app_options = {s3Location: options[:s3_bucket], s3Region: options[:s3_region]}

require_relative 'lib/rain_dance'
dance = RainDance.new(options[:artifacts_path], options[:manifest_file], app_options)
dance.do_jig!
