class Tagging < ActiveRecord::Base
  belongs_to :tag
  belongs_to :sit
  # attr_accessible :title, :body
end

# == Schema Information
#
# Table name: taggings
#
#  id         :integer          not null, primary key
#  tag_id     :integer
#  sit_id     :integer
#  created_at :datetime
#  updated_at :datetime
#
