class SessionsController < Devise::SessionsController

  layout 'sign_up'

  def new
    @title = 'Sign in'
    super
  end

end
