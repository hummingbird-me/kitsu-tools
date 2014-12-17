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

    def token
      Token.new(@request.cookies[TOKEN_FIELD])
    end
  end
end
