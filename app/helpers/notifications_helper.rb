module NotificationsHelper
  def unviewed_class_of(notification)
    'new-notification' unless notification.viewed
  end
end
