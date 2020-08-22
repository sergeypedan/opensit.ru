# frozen_string_literal: true

# https://github.com/thoughtbot/paperclip/blob/master/lib/paperclip/attachment.rb#L13

options = Paperclip::Attachment.default_options


if Rails.env.production?
  options[:storage] = :fog
  options[:fog_credentials] = {
    provider: 'AWS',
    aws_access_key_id: ENV['AWS_ACCESS_KEY_ID'],
    aws_secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'],
    region: 'eu-central-1',
    path_style: true
  }
  options[:fog_directory] = ENV['AWS_S3_BUCKET']
  options[:path] = "uploads/:class/:id/:style.:extension"
else
  options[:storage] = :filesystem
  options[:url] = "uploads/:class/:id/:style.:extension"
  options[:path] = ":rails_root/public/images/:url"
end

