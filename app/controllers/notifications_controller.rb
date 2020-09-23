class NotificationsController < ApplicationController

	before_action :authenticate_user!
	after_action :mark_as_read, only: :index

	def index
		@user          = current_user
		@notifications = @user.notifications.paginate(page: params[:page])
		@title 				 = t('notifications.my_notifications')
		@page_class    = 'notifications'
	end

	private

	def mark_as_read
		Notification.mark_all_as_read(current_user)
	end

end
