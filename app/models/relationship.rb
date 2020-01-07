class Relationship < ActiveRecord::Base

  belongs_to :follower, class_name: "User"
  belongs_to :followed, class_name: "User"

  validates :follower_id, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :followed_id, presence: true, numericality: { only_integer: true, greater_than: 0 }

end

# == Schema Information
#
# Table name: relationships
#
#  id          :integer          not null, primary key
#  followed_id :integer
#  follower_id :integer
#
