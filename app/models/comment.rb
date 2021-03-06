class Comment < ActiveRecord::Base

  belongs_to :user
  belongs_to :sit
  has_many :likes, as: :likeable

  # attr_accessor :body, :sit_id, :user_id

  validates :body, presence: true

  scope :newest_first, -> { order(created_at: :desc) }

  self.per_page = 10

  after_save :create_notification

  def self.latest(count = 5)
    self.newest_first.limit(count)
  end

  def likers
    Like.likers_for(self)
  end

  private

  def create_notification
    commenters = self.sit.commenters

    # Notify the owner of the sit
    Notification.send_new_comment_notification(self.sit.user.id, self, true)

    # And any other commenters
    if !commenters.empty?
      commenters.each do |c|
        Notification.send_new_comment_notification(c, self, false)
      end
    end
  end
end

# == Schema Information
#
# Table name: comments
#
#  id         :integer          not null, primary key
#  body       :text
#  sit_id     :integer
#  user_id    :integer
#
