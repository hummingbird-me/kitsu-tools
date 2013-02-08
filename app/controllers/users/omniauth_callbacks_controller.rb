class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook
    @user = User.find_for_facebook_oauth(request.env["omniauth.auth"], current_user)
    
    if @user.persisted?
      # TODO: add a flash message for successful sign in.
    else
      # TODO: add a flash message for successful sign up.
    end

    sign_in_and_redirect @user, :event => :authentication
  end
end
