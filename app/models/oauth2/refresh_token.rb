# OAuth2::RefreshToken is an OAuth2::Token which lasts 5 months and can only
# provide the 'oauth2_refresh' scope.
#
# This can be traded by the bearer of the client_secret for a new Token
# with the desired scopes.  Basically just an IOU for a Token, which is rarely
# transmitted over the network and thus remains more secure in the long-term.
class OAuth2::RefreshToken < OAuth2::Token
  def initialize(user, client, scopes, opts={})
    opts = {
      exp: (Time.now + 6.months.to_i).to_i,
      token_scopes: scopes
    }.merge(opts)
    super(user, client, %i[oauth2_refresh], opts)
  end

  def token_scopes
    @payload['token_scopes']
  end
end
