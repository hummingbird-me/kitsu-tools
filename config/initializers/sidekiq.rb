Sidekiq.default_worker_options = { backtrace: true }

Sidekiq.configure_server do |config|
  config.redis = { :url => "tcp://#{ENV['REDIS_HOST']}:6379/1" }
end

Sidekiq.configure_client do |config|
  config.redis = { :url => "tcp://#{ENV['REDIS_HOST']}:6379/1" }
end
