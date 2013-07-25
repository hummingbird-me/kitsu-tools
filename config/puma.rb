workers ENV['PUMA_WORKERS']
threads 0, 16

if ENV['RAILS_ENV'] == 'production'
  environment 'production'
  
  quiet
  directory '/u/apps/hummingbird/current'
  daemonize true
  pidfile '/u/apps/hummingbird/shared/pids/puma.pid'
  state_path '/u/apps/hummingbird/shared/puma.state'
  stdout_redirect '/u/apps/hummingbird/shared/log/puma.stdout.log',
                  '/u/apps/hummingbird/shared/log/puma.stderr.log'
  
  ENV["BUNDLE_GEMFILE"] ="/u/apps/hummingbird/current/Gemfile"
  
  bind 'unix:///tmp/puma.sock'
else
  environment 'development'
  
  bind 'tcp://0.0.0.0:3000'
end

preload_app!
drain_on_shutdown

on_restart do
  if defined?(ActiveRecord::Base)
    ActiveRecord::Base.connection.disconnect!
  end
  
  $redis.quit
end

on_worker_boot do
  if defined?(ActiveRecord::Base)
    ActiveRecord::Base.establish_connection
  end
  
  $redis = Redis.connect
end
