MessageBus.long_polling_enabled = true
MessageBus.long_polling_interval = 16000

MessageBus.redis_config = {
  host: ENV['REDIS_HOST']
}

MessageBus.user_id_lookup do |env|
  token = Rack::Request.new(env).cookies["token"]
  return nil unless token

  token = Token.new(token)
  if token.valid?
    token.user.try(:id)
  else
    nil
  end
end
