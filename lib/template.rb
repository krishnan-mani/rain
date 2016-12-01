require 'aws-sdk'

class TemplateLocal

  def initialize(template_path)
    @template_path = template_path
  end

  def get_template_element
    {"template_body": template_body}
  end

  def template_body
    File.open(@template_path, 'rb').read
  end

end


class TemplateInS3

  def initialize(template_path, artifacts_s3_bucket, artifacts_s3_region, template_key)
    @template_path = template_path
    @bucket = artifacts_s3_bucket
    @region = artifacts_s3_region
    @template_key = template_key
  end

  def upload_template
    s3 = Aws::S3::Client.new(region: @region)
    begin
      s3.head_bucket({
                         bucket: @bucket
                     })
    rescue Aws::S3::Errors::ServiceError => ex
      p "Error for s3 bucket #{@bucket}: #{ex.message}" #TODO: log errors
      s3.create_bucket({bucket: @bucket})
    end

    File.open(@template_path, 'rb') do |file|
      s3.put_object(
          bucket: @bucket,
          key: @template_key,
          body: file
      )
    end
    "https://s3.amazonaws.com/#{@bucket}/#{@template_key}"
  end

  def get_template_element
    {"template_url": upload_template}
  end

end