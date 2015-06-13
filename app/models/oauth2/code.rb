# OAuth2::Code is an OAuth2::Token which only lasts 5 minutes and can only
# provide the 'oauth2_code' scope.
#
# This can be traded by the bearer of the client_secret for an actual Token
# with the desired scopes.  Basically just an IOU for a Token.
class OAuth2::Code < OAuth2::Token
  def initialize(user, client, scopes, opts={})
    opts = {
      exp: 5.minutes.from_now.to_i,
      token_scopes: scopes
    }.merge(opts)
    super(user, client, %i[oauth2_code], opts)
  end

  def token_scopes
    @payload['token_scopes']
  end
end
