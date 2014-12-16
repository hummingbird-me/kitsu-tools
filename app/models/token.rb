class Token
  TTL = 3.months
  PREFIX = 'REVOKED:'

  class_attribute :secret

  def initialize(string_or_user, opts={})
    if string_or_user.is_a? String
      @payload = JWT.decode(string_or_user, secret)[0]
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

  def has_scope?(scope)
    @payload['scope'].include?(scope) || @payload['scope'].include?("all") if valid?
  end

  def expires_at
    Time.at(@payload['exp'])
  end

  def expires_in
    expires_at - Time.now
  end

  def expired?
    # Be extra careful about expiry, sometimes JWT shits itself
    @expired || expires_at < Time.now
  end

  def revoked?
    $redis.with { |conn| conn.exists(PREFIX + id) } unless id.nil?
  end

  def revoke!
    Token.revoke! id, expires_at
  end

  def self.revoke!(id, expiry)
    $redis.with do |conn|
      conn.set(PREFIX + id, Time.now)
      conn.expireat(PREFIX + id, expiry.to_i)
    end
  end

  def invalid?
    @invalid || expired? || revoked?
  end

  def valid?
    !invalid?
  end

  def user
    User.find(@payload['sub']) if valid?
  end

  def id
    @payload['jti'] unless @payload.nil?
  end

  def encode
    JWT.encode(@payload, secret)
  end
  alias_method :to_s, :encode
end
