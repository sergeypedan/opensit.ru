# http://stackoverflow.com/questions/4101220/rails-3-devise-how-to-skip-the-current-password-when-editing-a-registratio?rq=1

class RegistrationsController < Devise::RegistrationsController

  def after_sign_up_path_for(resource)
    '/welcome'
  end

  def after_sign_in_path_for(resource)
    (session[:"user.return_to"].nil?) ? "/" : session[:"user.return_to"].to_s
  end

	def edit
		@title      = t('profile.edit')
		@page_class = 'edit-profile'
	end

  def update
    super
    flash[:notice] = t('profile.messages.profile_updated')
  end

  def new
    @title = t('sign_up.title')
    @users = User.all.where.not(avatar_file_name: "").where("users.sits_count > 1").sample(6)
    super
  end

  def create
    email = params.dig(:user, :email)
    if email
      Blacklist::EMAIL_PATTERNS.each do |pattern|
        if email =~ pattern
          Rails.logger.error("Registration blocked via blacklist! #{email}")
          return redirect_to root_path, alert: t('sign_up.messages.registration_blocked', public_email: Rails.application.secrets.public_email)
        end
      end
    end
    @users = User.all.where.not(avatar_file_name: "").where("users.sits_count > 1").sample(6)
    super
  end

end
