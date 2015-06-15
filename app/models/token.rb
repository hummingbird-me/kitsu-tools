class Token
  TTL = 3.months
  PREFIX = 'REVOKED:'

  def self.secret
    Hummingbird::Application.config.jwt_secret
  end

  def initialize(user, opts={})
    user = user.id if user.is_a? User
    @payload = {
      'jti' => SecureRandom.uuid,
      'scope' => [],
      'sub' => user,
      'iat' => Time.now.to_i,
      'exp' => (Time.now + TTL.to_i).to_i
    }.merge(opts.stringify_keys)
  end

  def self.parse(str)
    # if it's nil, just send it to the Token.decode method
    return Token.decode(str) if str.blank?
    # parse without verifying just so we know which subclass to instantiate
    payload = JWT.decode(str, Token.secret, false)[0]

    if payload['scope'].include?('oauth2_code')
      OAuth2::Code.decode(str)
    elsif payload.has_key? 'client_id'
      OAuth2::Token.decode(str)
    else
      Token.decode(str)
    end
  rescue JWT::DecodeError
    # the `false` error flag in JWT.decode doesn't prevent JWT::DecodeError
    # from being raised.  Handle that here
    return Token.decode(str)
  end

  def self.decode(str)
    token = allocate
    token.instance_eval do
      begin
        @payload = JWT.decode(str, Token.secret)[0]
      rescue JWT::ExpiredSignature
        @expired = true
      rescue JWT::DecodeError
        @invalid = true
      end
    end
    token
  end

  def reissue
    fail 'Cannot reissue invalid token' if invalid?

    payload = @payload.dup
    %w[jti iat exp].each { |k| payload.delete(k) }

    Token.new(user, payload)
  end

  def scopes
    @payload['scope'] unless @payload.nil?
  end

  def has_scope?(scope)
    scopes.include?(scope.to_s) || scopes.include?("all") if valid?
  end

  def expires_at
    Time.at(@payload['exp']) unless @payload.nil?
  end

  def expires_in
    expires_at - Time.now unless @payload.nil?
  end

  def expired?
    return true if expires_at.nil?
    # Be extra careful about expiry, sometimes JWT shits itself
    @expired || expires_at < Time.now
  end

  def revoked?
    return true if @invalid
    $redis.with { |conn| conn.exists(PREFIX + id) } unless id.nil?
  end

  def revoke!
    Token.revoke! id, expires_at
  end

  def self.revoke!(id, expiry)
    $redis.with do |conn|
      conn.set(PREFIX + id, Time.now)
      # Expire 5 minutes after the token itself expires, just to make sure
      # clock drift doesn't open an exploit
      conn.expireat(PREFIX + id, expiry.to_i + 5.minutes)
    end
  end

  def invalid?
    @invalid || expired? || revoked?
  end

  def valid?
    !invalid?
  end

  def user
    User.find_by(id: @payload['sub']) if valid?
  end

  def id
    @payload['jti'] unless @payload.nil?
  end

  def encode
    JWT.encode(@payload, Token.secret)
  end
  alias_method :to_s, :encode
end
