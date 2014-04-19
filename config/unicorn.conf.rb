worker_processes ENV["UNICORN_PROCESSES"].to_i 

if ENV["RAILS_ENV"] == "production"

  working_directory "/u/apps/hummingbird/current"
  listen "/tmp/unicorn.sock", backlog: 1024
  pid "/u/apps/hummingbird/shared/pids/unicorn.pid"
  stderr_path "/u/apps/hummingbird/shared/log/unicorn.stderr.log"
  stdout_path "/u/apps/hummingbird/shared/log/unicorn.stdout.log"

  # Force the bundler gemfile environment variable to reference the Capistrano
  # "current" symlink.
  before_exec do |server|
    ENV["BUNDLE_GEMFILE"] ="/u/apps/hummingbird/current/Gemfile"
  end
else

  listen 3000, tcp_nopush: true

end


preload_app true
if GC.respond_to?(:copy_on_write_friendly=)
  GC.copy_on_write_friendly = true
end

# Nuke workers after 60 seconds.
timeout 60

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
  if defined?(ActiveRecord::Base)
    ActiveRecord::Base.connection.disconnect!
  end

  $redis.quit

  # Zero downtime deploys.
  #
  old_pid = "#{server.config[:pid]}.oldbin"
  if File.exists?(old_pid) and server.pid != old_pid
    begin
      Process.kill("QUIT", File.read(old_pid).to_i)
    rescue Errno::ENOENT, Errno::ESRCH
      # Someone else did our job for us.
    end
  end
end

after_fork do |server, worker|
  # per-process listener ports for debugging/admin/migrations
  # addr = "127.0.0.1:#{9293 + worker.nr}"
  # server.listen(addr, :tries => -1, :delay => 5, :tcp_nopush => true)

  # the following is *required* for Rails + "preload_app true",
  if defined?(ActiveRecord::Base)
    ActiveRecord::Base.establish_connection
  end

  # if preload_app is true, then you may also want to check and
  # restart any other shared sockets/descriptors such as Memcached,
  # and Redis.  TokyoCabinet file handles are safe to reuse
  # between any number of forked children (assuming your kernel
  # correctly implements pread()/pwrite() system calls)
  $redis = Redis.connect(host: ENV['REDIS_HOST'])
end

