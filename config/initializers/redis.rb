def get_new_redis_pool
  ConnectionPool.new(size: 10, timeout: 5) do
    Redis.new(driver: :hiredis, host: ENV['REDIS_HOST'])
  end
end

$redis = get_new_redis_pool
