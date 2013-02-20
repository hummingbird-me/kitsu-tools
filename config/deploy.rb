require 'rvm/capistrano'
require 'sidekiq/capistrano'
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
  task :nginx_symlink_reload, roles: :web do
    if capture("diff #{release_path}/config/nginx.conf /etc/nginx/sites-enabled/hummingbird | wc -l").to_i > 0
      run "#{sudo} ln -nfs #{release_path}/config/nginx.conf /etc/nginx/sites-enabled/hummingbird"
      run "#{sudo} service nginx reload"
    end
  end
  
  desc "symlink monit configuration"
  task :monit_symlink_reload, roles: :web do
    if capture("diff #{release_path}/config/monit.conf /etc/monit/conf.d/hummingbird.conf | wc -l").to_i > 0
      run "#{sudo} ln -nfs #{release_path}/config/monit.conf /etc/monit/conf.d/hummingbird.conf"
      run "#{sudo} monit reload"
    end
  end
  
  desc "start the app"
  task :start, roles: :web do
    run "#{sudo} monit -g hummingbird start"
  end
  
  desc "stop the app"
  task :stop, roles: :web do
    run "#{sudo} monit -g hummingbird stop"
  end
  
  desc "restart the app"
  task :restart, roles: :web do
    # Stop sidekiq, reload unicorn, run migrations and start sidekiq.
    run "kill -USR2 `cat /u/apps/hummingbird/shared/pids/unicorn.pid`"
    run "cd #{current_release} && RAILS_ENV=production bundle exec rake db:migrate"
  end
  
  namespace :assets do
    task :precompile, roles: :web, except: {no_release: true} do
      from = source.next_revision(current_revision)
      if capture("cd #{latest_release} && #{source.local.log(from)} vendor/assets/ app/assets/ | wc -l").to_i > 0
        run <<-CMD.compact
          cd -- #{latest_release} &&
          #{rake} RAILS_ENV=#{rails_env.to_s.shellescape} #{asset_env} assets:precompile &&
          cp -- #{shared_path.shellescape}/assets/manifest.yml #{current_release.shellescape}/assets_manifest.yml
        CMD
      else
        logger.info "Skipping asset pre-compilation because there were no asset changes"
      end
    end
  end
end

after "deploy:restart",
  "deploy:nginx_symlink_reload", "deploy:monit_symlink_reload"

# To keep only the last 5 releases:
# (Default is `set :keep_releases, 5`)
after "deploy:restart", "deploy:cleanup"
