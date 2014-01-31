$redis = Redis.new(driver: :hiredis, host: ENV['REDIS_HOST'])
Split.redis = $redis
