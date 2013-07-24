workers ENV['PUMA_WORKERS']
threads 0, 16

if ENV['RAILS_ENV'] == 'production'
  environment 'production'
  
  directory '/u/apps/hummingbird/current'
  daemonize true
  pidfile '/u/apps/hummingbird/shared/pids/puma.pid'
  state_path '/u/apps/hummingbird/shared/puma.state'
  stdout_redirect '/u/apps/hummingbird/shared/log/puma.stdout.log'
  stderr_redirect '/u/apps/hummingbird/shared/log/puma.stderr.log'
  
  ENV["BUNDLE_GEMFILE"] ="/u/apps/hummingbird/current/Gemfile"
  
  bind 'unix:///tmp/puma.sock'
else
  environment 'development'
  
  bind 'tcp://0.0.0.0:3000'
end
