require_dependency 'auth/current_user_provider'

module Auth
  module Helpers
    OLD_COOKIE = "auth_token".freeze
    CURRENT_USER_PROVIDER_KEY = "_CURRENT_USER_PROVIDER".freeze

    def current_user
      env[CURRENT_USER_PROVIDER_KEY].current_user
    end

    def user_signed_in?
      env[CURRENT_USER_PROVIDER_KEY].user_signed_in?
    end

    def authenticate_user!
      env[CURRENT_USER_PROVIDER_KEY].authenticate_user!
    end

    # Upgrade auth token, set up CurrentUserProvider, refresh token if needed,
    # log IP address.
    def check_user_authentication
      if cookies[OLD_COOKIE]
        user = User.where(authentication_token: cookies[OLD_COOKIE]).first
        cookies.delete("auth_token", domain: :all)
        sign_in(user) if user
      end

      env[CURRENT_USER_PROVIDER_KEY] ||= Auth::CurrentUserProvider.new(env)
      current_user_provider = env[CURRENT_USER_PROVIDER_KEY]

      if user_signed_in?
        sign_in(current_user) if current_user_provider.token.expires_in < 1.month
        current_user.update_ip! request.remote_ip
      end
    end
  end
end
