class Tagging < ActiveRecord::Base

  belongs_to :tag
  belongs_to :sit

  attr_accessor :title, :body

end

# == Schema Information
#
# Table name: taggings
#
#  id         :integer          not null, primary key
#  sit_id     :integer
#  tag_id     :integer
#
