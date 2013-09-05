Sidekiq.configure_server do |config|
  config.redis = { :url => "tcp://#{ENV['REDIS_HOST']}:6379/1" }
  config.server_middleware do |chain|
    chain.add Sidekiq::Throttler
  end
end

Sidekiq.configure_client do |config|
  config.redis = { :url => "tcp://#{ENV['REDIS_HOST']}:6379/1" }
end
