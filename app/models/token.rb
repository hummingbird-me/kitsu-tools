class Token
  TTL = 3.months
  PREFIX = 'REVOKED:'

  def self.secret
    Hummingbird::Application.config.jwt_secret
  end

  def initialize(string_or_user, opts={})
    if string_or_user.is_a? String
      @payload = JWT.decode(string_or_user, Token.secret)[0]
    else
      string_or_user = string_or_user.id if string_or_user.is_a? User
      @payload = {
        'jti' => SecureRandom.uuid,
        'scope' => [],
        'sub' => string_or_user,
        'iss' => Time.now.to_i,
        'exp' => TTL.from_now.to_i
      }.merge(opts.stringify_keys)
    end
  rescue JWT::ExpiredSignature
    @expired = true
  rescue JWT::DecodeError
    @invalid = true
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
