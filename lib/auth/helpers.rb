require_dependency 'auth/provider'
require_dependency 'auth/unauthorized_exception'

module Auth
  module Helpers
    def auth_provider
      @auth_provider ||= Auth::Provider.new(env, cookies)
    end

    def current_user
      auth_provider.current_user
    end

    def user_signed_in?
      auth_provider.signed_in?
    end

    def authenticate_user!(scope = :site)
      fail UnauthorizedException unless auth_provider.scope?(scope)
    end

    # Refresh token if needed, log IP address.
    def housekeep_tokens
      if auth_provider.signed_in?
        # If the token is valid and expiring soon, renew it
        token = auth_provider.token
        if token.valid? && token.expires_in < 1.month
          auth_provider.reissue_cookie!
        end
        current_user.update_ip!(request.remote_ip)
      end
    end
  end
end
