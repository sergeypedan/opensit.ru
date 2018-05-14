class Like < ActiveRecord::Base

  belongs_to :likeable
  belongs_to :user

  validates :user_id, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :likeable_id, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :likeable_type, presence: true

  # attr_accessor :user_id, :likeable_type, :likeable_id

  after_save :create_notification

  class << self

    def likers_for(record)
      # user_ids = record.likes.map(&:user_id).order
      # User.find(user_ids)
      record.likes.order(id: :asc).map { |like| User.find(like.user_id) }
    end

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
#  id            :bigint(8)        not null, primary key
#  likeable_type :string
#  likeable_id   :bigint(8)
#  user_id       :bigint(8)
#
