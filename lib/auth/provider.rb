module Auth
  class Provider
    # Cookie names
    TOKEN ||= 'token'.freeze
    MASQUERADE ||= '_masquerade'.freeze

    def initialize(env, cookies)
      @env = env
      @cookies = cookies
      @current_user = nil
    end

    def current_user
      return @current_user unless @current_user.nil?
      return User.find(@env[MASQUERADE]) if @env.key?(MASQUERADE)

      # If there's no overrides or fastpaths, just grab the token user
      @current_user = token.user if @cookies[TOKEN]
    end

    def signed_in?
      return true if @env.key?(MASQUERADE)
      return false if token.invalid?
      !!current_user
    end

    def scope?(scope)
      # Masquerade mode has the scope
      return true if @env.key?(MASQUERADE)
      # Otherwise, false if they're not signed in or don't have the scope
      return false unless signed_in?
      return false unless token.has_scope?(scope)
      true
    end

    def issue_cookie(token)
      @cookies[TOKEN] = {
        value: token.encode,
        expires: token.expires_at,
        domain: :all,
        httponly: true
      }
    end

    def reissue_cookie!
      issue_cookie(token.reissue)
    end

    def sign_in(user)
      issue_cookie(Token.new(user))
      @current_user = user
    end

    def sign_out
      @cookies.delete(TOKEN, domain: :all)
      @current_user = nil
    end

    def token
      Token.parse(@cookies[TOKEN])
    end

  end
end
