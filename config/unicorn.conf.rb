worker_processes 16
working_directory "/u/apps/hummingbird/current"

preload_app true
# Memory savings when we switch to Ruby 2.0
if GC.respond_to?(:copy_on_write_friendly=)
  GC.copy_on_write_friendly = true
end

# Listen on a Unix domain socket. Backlog setting needs tweaking.
listen "/tmp/unicorn.sock", backlog: 1024
# Uncomment to listen on a TCP socket.
# listen 8080, :tcp_nopush => true

# Nuke workers after 30 seconds.
timeout 30

# PID file.
pid "/u/apps/hummingbird/shared/pids/unicorn.pid"

# By default, the Unicorn logger will write to stderr.
# Additionally, ome applications/frameworks log to stderr or stdout,
# so prevent them from going to /dev/null when daemonized here:
stderr_path "/u/apps/hummingbird/shared/log/unicorn.stderr.log"
stdout_path "/u/apps/hummingbird/shared/log/unicorn.stdout.log"

# Enable this flag to have unicorn test client connections by writing the
# beginning of the HTTP headers before calling the application.  This
# prevents calling the application for connections that have disconnected
# while queued.  This is only guaranteed to detect clients on the same
# host unicorn runs on, and unlikely to detect disconnects even on a
# fast LAN.
check_client_connection false

# Force the bundler gemfile environment variable to reference the Capistrano
# "current" symlink.
before_exec do |server|
  ENV["BUNDLE_GEMFILE"] ="/u/apps/hummingbird/current/Gemfile"
end

before_fork do |server, worker|
  # the following is highly recomended for Rails + "preload_app true"
  # as there's no need for the master process to hold a connection
  if defined?(ActiveRecord::Base)
    ActiveRecord::Base.connection.disconnect!
  end

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
  $redis = Redis.connect
end

