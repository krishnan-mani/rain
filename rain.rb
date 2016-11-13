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

  opts.on('-s3bucket', '--s3-bucket bucket', 'Specify an S3 bucket and S3 region') do |bucket|
    options[:s3_bucket] = bucket
  end

  opts.on('-s3region', '--s3-region region', 'Specify an S3 bucket and S3 region') do |region|
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
