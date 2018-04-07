class UserMailer < ApplicationMailer

  def new_design(user)
    @email = user.email
    @name  = user.display_name

    mail(to: @email, subject: "Psst.. OpenSit has changed!")
	end

	def welcome_email(user)
		@email = user.email
		mail(to: @email, subject: 'Welcome to the community!') if @email
	end

	def blog_is_live(user)
		@email = user.email
		mail(to: @email, subject: 'The OpenSit Blog is Live!') if @email
	end

  def goals_are_live(user)
    @email = user.email
    mail(to: @email, subject: 'Set goals for your meditation') if @email
  end

  # 11th Jan 2015
  def calendar_intro_email(user)
    @email = user.email
    mail(to: @email, subject: 'Meditate with people from around the globe!') if @email
  end

  def opensit_survey(user)
    @email = user.email
    mail(to: @email, subject: 'OpenSit is changing... what do you think?') if @email
  end
end
