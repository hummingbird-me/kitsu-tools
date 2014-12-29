MessageBus.long_polling_enabled = true
MessageBus.long_polling_interval = 16000

MessageBus.redis_config = {
  host: ENV['REDIS_HOST']
}

MessageBus.user_id_lookup do |env|
  token = Rack::Request.new(env).cookies["token"]

  if token
    t = Token.new(token)
    t.valid? ? t.user.try(:id) : nil
  else
    nil
  end
end
