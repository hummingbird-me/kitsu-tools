module AuthHelpers
  TOKEN_FIELD = "token".freeze
  OLD_COOKIE = "auth_token".freeze

  # Upgrade from auth_token to token by signing them in again
  def upgrade_token!
    if user_signed_in?
      user = User.find_by(authentication_token: cookies[OLD_COOKIE])
      sign_in user
    end
  end

  def token
    token = cookies[TOKEN_FIELD]
    token ||= params[TOKEN_FIELD] unless request.get?
    Token.new(token)
  end

  def current_user
    if cookies[TOKEN_FIELD] && token.valid?
      token.user
    else
      super
    end
  end

  def user_signed_in?
    if cookies[TOKEN_FIELD]
      !!current_user
    else
      super
    end
  end

  def authenticate_user!
    if cookies[TOKEN_FIELD]
      unless user_signed_in?
        render json: {error: 'Not authenticated'}, status: 403
      end
    else
      super
    end
  end

  # Upgrades the token, refreshes it, and clears invalid ones
  def check_user_authentication
    if cookies[TOKEN_FIELD]
      if !user_signed_in?
        sign_out :user
      else
        sign_in current_user if token.expires_in < 1.month
        current_user.update_ip! request.remote_ip
      end
    elsif cookies[OLD_COOKIE]
      # Sign the user out if they have an incorrect auth token.
      if user_signed_in?
        sign_out :user if current_user.authentication_token != cookies[OLD_COOKIE]
      else
        user = User.find_by(authentication_token: cookies[OLD_COOKIE])
        user.update_ip! request.remote_ip

        sign_in(user) if user
      end
    end
  end
end
