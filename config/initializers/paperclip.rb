# frozen_string_literal: true

# https://github.com/thoughtbot/paperclip/blob/master/lib/paperclip/attachment.rb#L13

options = Paperclip::Attachment.default_options

options[:storage] = :filesystem
options[:url] = "uploads/:class/:id/:style.:extension"
options[:path] = ":rails_root/public/images:url"
