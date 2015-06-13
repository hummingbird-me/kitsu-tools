# OAuth2::Token is a Token which is bound to a specific client id
class OAuth2::Token < Token
  CLIENT_REVOCATION_PREFIX = 'REVOKED:CLIENT-AND-USER:'

  def initialize(user, client, scopes, opts={})
    client = client.id if client.is_a? App
    opts = { client_id: client, scope: scopes }.merge(opts)
    super(user, opts)
  end

  def self.from_code(code)
    code = OAuth2::Code.decode(code) if code.is_a? String
    token = OAuth2::Token.new(code.user, code.client, code.token_scopes)
    code.revoke!
    token
  end

  def client
    App.find(@payload['client_id'])
  end

  def self.revoke!(user, client, expiry = TTL.from_now)
    user = user.id if user.is_a? User
    client = client.id if client.is_a? App

    $redis.with do |conn|
      key = "#{CLIENT_REVOCATION_PREFIX}#{client}:#{user}"
      conn.set(key, Time.now.to_i)
      conn.expireat(key, expiry.to_i + 5.minutes)
    end
  end

  def revoked?
    $redis.with do |conn|
      client_id = @payload['client_id']
      user_id = @payload['sub']
      revoked = conn.get("#{CLIENT_REVOCATION_PREFIX}#{client_id}:#{user_id}")
      # If the revocation time is after the issuance, we consider it revoked
      revoked && revoked.to_i > @payload['iat']
      # Or if the superclass says it's revoked
    end || super
  end
end
