class UserMailer < ApplicationMailer

  def new_design(user)
    @email = user.email
    @name  = user.display_name

    mail(to: @email, subject: I18n.t('email.subject.new_design'))
	end

	def welcome_email(user)
		@email = user.email
		mail(to: @email, subject: I18n.t('email.subject.welcome_email')) if @email
	end

	def blog_is_live(user)
		@email = user.email
		mail(to: @email, subject: I18n.t('email.subject.blog_is_live')) if @email
	end

  def goals_are_live(user)
    @email = user.email
    mail(to: @email, subject: I18n.t('email.subject.goals_are_live')) if @email
  end

  # 11th Jan 2015
  def calendar_intro_email(user)
    @email = user.email
    mail(to: @email, subject: I18n.t('email.subject.calendar_intro_email')) if @email
  end

  def opensit_survey(user)
    @email = user.email
    mail(to: @email, subject: I18n.t('email.subject.opensit_survey')) if @email
  end
end
