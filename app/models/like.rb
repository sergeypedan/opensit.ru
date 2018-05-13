class Like < ActiveRecord::Base

  belongs_to :likeable
  belongs_to :user

  validates :user_id, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :likeable_id, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :likeable_type, presence: true

  # attr_accessor :user_id, :likeable_type, :likeable_id

  after_save :create_notification

  def self.likers_for(obj)
    obj.likes.order(id: :asc).map { |u| User.find(u.user_id) }
  end

  private
    def create_notification
      @obj = self.likeable_type.constantize.find(self.likeable_id)
      Notification.send_new_sit_like_notification(@obj.user.id, self)
    end
end

# == Schema Information
#
# Table name: likes
#
#  id            :integer          not null, primary key
#  likeable_id   :integer
#  likeable_type :string
#  user_id       :integer
#
