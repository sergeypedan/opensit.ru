class Notification < ActiveRecord::Base

  belongs_to :user

  validates :message, presence: true
  validates :user_id, presence: true, numericality: { only_integer: true, greater_than: 0 }

  default_scope { order(created_at: :desc) }

  scope :unread, -> { where(viewed: false) }

  self.per_page = 10

  # user_id = ID of the RECIPIENT
  def self.send_new_comment_notification(user_id, comment, mine)
    username = comment.user.display_name
    sit_owner = comment.sit.user.display_name
    message = if mine
                I18n.t('notifications.commented_on_your_sit', username: username)
              else
                if sit_owner == username
                  I18n.t('notifications.commented_on_their_own_sit', username: username)
                else
                  I18n.t(
                    'notifications.commented_on_sit_owner_sit',
                    username: username,
                    sit_owner: sit_owner
                  )
                end
              end

    # No need to notify the user if they've just commented on their own sit
    if comment.user.id != user_id
      Notification.create(
        message: message,
        user_id: user_id,
        link: "/sits/#{comment.sit.id}\#comment-#{comment.id}",
        initiator: comment.user.id,
        object_type: 'comment',
        object_id: comment.id
      )
    end

  end

  # user_id = ID of the RECIPIENT
  def self.send_new_follower_notification(user_id, follow)

    Notification.create(
      message: I18n.t("notifications.following_you", username: follow.follower.display_name),
      user_id: user_id,
      link: Rails.application.routes.url_helpers.user_path(follow.follower),
      initiator: follow.follower.id,
      object_type: 'follow',
      object_id: follow.id
    )

  end

  def self.send_new_sit_like_notification(user_id, like)

    obj = Sit.find(like.likeable_id)
    last_notification = User.find(user_id).notifications.first

    # if last notification was a like of the same sit
    if can_combine_likes?(last_notification, like)

      likes_count = Like.likers_for(obj).count
      if likes_count == 2
        message = I18n.t("notifications.other_person_liked_your_entry", username: like.user.display_name)
      else
        message = I18n.t(
          "notifications.other_person_liked_your_entry",
          username: like.user.display_name,
          likes_count: likes_count - 1
        )
      end
      last_notification.update(
        message: message,
        initiator: like.user.id
      )

    else

      Notification.create(
        message: I18n.t("notifications.likes_your_entry", username: like.user.display_name),
        user_id: user_id,
        link: Rails.application.routes.url_helpers.sit_path(like.likeable_id),
        initiator: like.user.id,
        object_type: 'like',
        object_id: like.id
      )

    end


  end

  def self.mark_all_as_read(current_user)
    @user = current_user
    @notifications = @user.notifications.unread
    @notifications.each do |n|
      n.viewed = true
      n.save
    end
  end

  private

    def self.can_combine_likes?(last_notification, like)
      last_notification.present? and last_notification.object_id == like.likeable_id and last_notification.object_type == 'like'
    end
end

# == Schema Information
#
# Table name: notifications
#
#  id          :integer          not null, primary key
#  initiator   :integer
#  link        :string
#  message     :string
#  object_type :string
#  viewed      :boolean          default(FALSE)
#  object_id   :integer
#  user_id     :integer
#
