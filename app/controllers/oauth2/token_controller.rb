# WARNING: IF YOU HAVE NOT READ RFC 6749, DO NOT TOUCH THIS.
#
# Throughout this file there are references to RFC 6749 in parentheses.  The
# numbers separated by dots are the section id from the spec, the number after
# "P" is the paragraph, and "S" is sentence.

class OAuth2::TokenController < ApplicationController
  # Scattered throughout RFC 6794
  GRANT_TYPES = %w[authorization_code refresh_token password client_credentials]
  # Valid response errors (5.2)
  VALID_ERRORS = {
    invalid_request: 400,
    invalid_client: 401,
    invalid_grant: 400,
    invalid_scope: 400,
    unauthorized_client: 400,
    unsupported_grant_type: 400,
    server_error: 500
  }

  def token
    response.headers['Cache-Control'] = 'no-cache, no-store, must-revalidate'
    response.headers['Pragma'] = 'no-cache'
    response.headers['Expires'] = 'Fri, 01 Jan 1990 00:00:00 GMT'

    return error! :invalid_client unless valid_client?
    return error! :unsupported_grant_type unless grant_type

    token = send("#{grant_type}_grant")
    return unless token.is_a? OAuth2::Token

    refresh = OAuth2::RefreshToken.new(token.user, token.client, token.scopes)
    give_token!(token, refresh)
  end

  private

  def authorization_code_grant
    code = OAuth2::Code.decode(params[:code])
    # TODO: save redirect_uri in Code, check it here
    _redirect_uri = params[:redirect_uri]

    return error! :invalid_grant unless code.valid?
    return error! :unauthorized_client unless code.client == client

    OAuth2::Token.from_code(code)
  end

  def refresh_token_grant
    # REVIEW: does this endpoint require scopes?
    refresh_token = OAuth2::RefreshToken.decode(params[:refresh_token])

    return error! :invalid_grant unless refresh_token.valid?
    return error! :unauthorized_client unless refresh_token.client == client

    OAuth2::Token.from_refresh_token(refresh_token)
  end

  def password_grant
    return error! :unauthorized_client unless client.privileged?
    return error! :invalid_scope unless client.scopes_allowed?(scopes)

    user = User.find_by_login(params[:username])
    pass = params[:password]

    return error! :invalid_grant unless user && user.valid_password?(pass)

    OAuth2::Token.new(user, client, scopes)
  end

  def client_credentials_grant
    # TODO: find an actual use for this
    return error! :unsupported_grant_type
  end

  def grant_type
    params[:grant_type].to_sym if GRANT_TYPES.include?(params[:grant_type])
  end

  def valid_client?
    key, secret = client_credentials
    return false unless key && secret

    client = App.where(key: key).first
    # Constant-time comparison to prevent timing attacks
    Rack::Utils.secure_compare(client.secret, secret)
  end

  def client
    App.where(key: client_credentials[0]).first
  end

  def scopes
    params[:scopes].split(' ') if params.key? :scopes
  end

  def has_basic_credentials?
    ActionController::HttpAuthentication::Basic.has_basic_credentials?(request)
  end

  def basic_credentials
    ActionController::HttpAuthentication::Basic.user_name_and_password(request)
  end

  def client_credentials
    if has_basic_credentials?
      basic_credentials
    elsif params.key?(:client_id) && params.key(:client_secret)
      [params[:client_id], params[:client_secret]]
    else
      nil
    end
  end

  def error!(err, message = nil, uri: nil)
    error :server_error unless VALID_ERRORS.key?(err)
    render status: VALID_ERRORS[err], json: {
      error: err,
      error_description: message,
      error_uri: uri
    }.compact!
  end

  def give_token!(token, refresh_token = nil)
    render json: {
      access_token: token.encode,
      token_type: 'bearer',
      refresh_token: refresh_token.encode,
      expires_in: token.expires_in.to_i,
      scope: token.scopes.join(' ')
    }
  end
end
