# NOTE: This class uses Rails views in a non-legacy manner.  This is by design.
# Do not attempt to Emberize this controller without first studying the
# potential security effects it may have (namely CSRF)
#
# WARNING: IF YOU HAVE NOT READ RFC 6749, DO NOT TOUCH THIS.
#
# Throughout this file there are references to RFC 6749 in parentheses.  The
# numbers separated by dots are the section id from the spec, the number after
# "P" is the paragraph, and "S" is sentence.
class OAuth2::AuthorizationController < ApplicationController
  # Valid response errors (4.1.2.1, 4.2.2.1)
  VALID_ERRORS = %i[invalid_request unauthorized_client access_denied
                    unsupported_response_type invalid_scope server_error
                    temporarily_unavailable]
  # Not specified by RFC 6749, these are internal
  VALID_FATAL_ERRORS = %i[invalid_client invalid_redirect]

  # Request an authorization from the user to the client
  def ask
    # Prevent clickjacking via headers.  The template also has a framebuster
    # which is blatantly ripped from OWASP wiki and prevents many common
    # framebuster workarounds.
    response.headers['X-Frame-Options'] = 'DENY'
    response.headers['Content-Security-Policy'] = "frame-ancestors 'none'"

    @app = client
    @redirect_uri = params[:redirect_uri]
    @scopes = params[:scopes]

    # REVIEW: should we also check these on the #authorize action?
    return fatal_error! :invalid_client unless client
    return fatal_error! :readonly_client unless client.write_access?
    return fatal_error! :invalid_redirect unless valid_redirect?
    return error! :unsupported_response_type unless valid_response_type?
    return error! :invalid_scope unless valid_scopes?

    render :ask
  rescue
    if Rails.env.production?
      error! :server_error
    else
      raise
    end
  end

  # User confirmed that they wish to authorize the client, redirect back to
  # client.
  def give
    # If yes, issue OAuth2::Code and redirect to client
    if params[:accept]
      if params[:response_type] == 'token'
        token = OAuth2::Token.new(current_user, client, scopes)
        redirect_back! token: token
      else
        code = OAuth2::Code.new(current_user, client, scopes)
        redirect_back! code: code
      end
    else
      return error! :access_denied
    end
  rescue
    if Rails.env.production?
      error! :server_error
    else
      raise
    end
  end

  private

  def scopes
    params[:scope].split(' ')
  end

  def client
    App.where(key: params[:client_id]).first
  end

  def valid_redirect?
    client.redirect_allowed?(params[:redirect_uri])
  end

  def valid_scopes?
    client.scopes_allowed?(scopes)
  end

  def valid_response_type?
    %w[code token].include?(params[:response_type])
  end

  # OAuth2 has specific error protocols to report back to the redirect endpoint
  # since normal HTTP status codes don't work (4.1.2.1, 4.2.2.1)
  def error!(err, message=nil, uri: nil)
    error! :server_error unless VALID_ERRORS.include?(err)
    redirect_back!({
      error: err,
      error_description: message,
      error_uri: uri
    }.compact!)
  end

  # Fatal errors are ones which should be displayed to the user without calling
  # the redirect endpoint. ex: invalid client_id or redirect_uri (4.1.2.1P1)
  def fatal_error!(err)
    @error = err
    render :error, status: 400
  end

  # Redirect back to the application with payload
  def redirect_back!(obj)
    # State parameter to help clients prevent CSRF (10.12)
    obj = { state: params[:state] }.merge(obj).compact

    uri = if params[:response_type] == 'token'
            client.build_redirect_uri(:fragment, obj)
          else
            client.build_redirect_uri(:query_string, obj)
          end

    redirect_to uri, status: 302
  end
end
