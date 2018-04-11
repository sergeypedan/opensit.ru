class SessionsController < Devise::SessionsController

  layout 'authentication'

  def new
    @title = 'Sign in'
    super
  end

end
