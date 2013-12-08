require 'devise/strategies/authenticatable'

Warden::Strategies.add(:cookie_auth) do
  def valid?
    true
  end

  def authenticate!
    auth_token = request.cookies['auth_token'] || params['auth_token']
    if auth_token and auth_token.strip.length > 0
      user = User.where(authentication_token: auth_token).first
      if user
        success! user
        return
      end
    end
    # TODO: Change this to `fail!` once registration and login are made part of the
    # Ember application.
    fail
  end
end
