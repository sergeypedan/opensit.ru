class SessionsController < Devise::SessionsController

  def new
    @title = t('sign_in.session')
    super
  end

end
