require 'rvm/capistrano'
require 'bundler/capistrano'

set :application, "hummingbird"
set :repository,  "git@github.com:vikhyat/hummingbird.git"

set :scm, :git
set :deploy_via, :remote_cache
set :rvm_type, :user

default_run_options[:pty] = true

server "hakanai", :app, :web, :db, primary: true
#role :db,  "your slave db-server here"

#
# CUSTOM TASKS
#

namespace :deploy do
  desc "symlink nginx configuration"
  task :nginx_symlink, roles: :web do
    run "#{sudo} ln -nfs #{release_path}/config/nginx.conf /etc/nginx/sites-enabled/hummingbird"
  end
  
  desc "reload nginx configuration"
  task :nginx_reload, roles: :web do
    run "#{sudo} service nginx reload"
  end
end

after "deploy:finalize_update",
  "deploy:nginx_symlink"

after "deploy:restart",
  "deploy:nginx_reload"

# To keep only the last 5 releases:
# after "deploy:restart", "deploy:cleanup"
