hummingbird_path = File.expand_path(File.expand_path(File.dirname(__FILE__)) + "/../")

worker_processes ENV["UNICORN_WORKERS"].to_i
working_directory hummingbird_path
listen 3000

# Nuke workers after 20 seconds.
timeout 20

# Reduces memory usage in Ruby 2.0+.
preload_app true

pid "#{hummingbird_path}/tmp/pids/unicorn.pid"

if ENV['RAILS_ENV'] == 'production'
  stderr_path "#{hummingbird_path}/log/unicorn.stderr.log"
  stdout_path "#{hummingbird_path}/log/unicorn.stdout.log"
end

# Enable this flag to have unicorn test client connections by writing the
# beginning of the HTTP headers before calling the application.  This
# prevents calling the application for connections that have disconnected
# while queued.  This is only guaranteed to detect clients on the same
# host unicorn runs on, and unlikely to detect disconnects even on a
# fast LAN.
check_client_connection false

before_fork do |server, worker|
  # the following is highly recomended for Rails + "preload_app true"
  # as there's no need for the master process to hold a connection
  ActiveRecord::Base.connection.disconnect!
  $redis.shutdown {|conn| conn.close }

  # For zero downtime deploys.
  old_pid = "#{server.config[:pid]}.oldbin"
  if File.exists?(old_pid) && server.pid != old_pid
    begin
      Process.kill("QUIT", File.read(old_pid).to_i)
    rescue Errno::ENOENT, Errno::ESRCH
      # Someone else did our job for us.
    end
  end

  # Throttle master from forking too quickly. Partially prevents identical
  # repeated signals from being lost when the receiving process is busy.
  sleep 1
end

after_fork do |server, worker|
  # the following is *required* for Rails + "preload_app true",
  ActiveRecord::Base.establish_connection
  $redis = get_new_redis_pool
  MessageBus.after_fork
end

