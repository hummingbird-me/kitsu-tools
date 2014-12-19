require_dependency 'auth/unauthorized_exception'

module Auth
  class CurrentUserProvider
    CURRENT_USER_KEY = "_CURRENT_USER".freeze
    TOKEN_FIELD = "token".freeze
    OLD_COOKIE = "auth_token".freeze

    def initialize(env)
      @env = env
      @request = Rack::Request.new(env)
    end

    def current_user
      return @env[CURRENT_USER_KEY] if @env.key?(CURRENT_USER_KEY)

      if @request.cookies[TOKEN_FIELD]
        @env[CURRENT_USER_KEY] = token.user
      else
        @env[CURRENT_USER_KEY] = nil
      end

      @env[CURRENT_USER_KEY]
    end

    def user_signed_in?
      !!current_user
    end

    def authenticate_user!
      unless user_signed_in?
        raise UnauthorizedException.new
      end
    end

    def log_on_user(user, cookies)
      new_token = Token.new(user.id, scope: ['all'])
      cookies[TOKEN_FIELD] = {
        value: new_token.encode,
        expires: new_token.expires_at,
        domain: :all,
        httponly: true
      }
      @env[CURRENT_USER_KEY] = user
    end

    def log_off_user(cookies)
      cookies.delete(TOKEN_FIELD, domain: :all)
      @env[CURRENT_USER_KEY] = nil
    end

    def token
      Token.new(@request.cookies[TOKEN_FIELD])
    end
  end
end
