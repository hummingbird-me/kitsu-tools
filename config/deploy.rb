require 'sidekiq/capistrano'
require 'bundler/capistrano'
require 'new_relic/recipes'

set :application, "hummingbird"
set :repository,  "git@github.com:JoshFabian/hummingbird-v2.git"

set :scm, :git
set :user, "root"
set :git_enable_submodules, 1
set :deploy_via, :remote_cache
set :sidekiq_role, :sidekiq

default_run_options[:pty] = true
default_run_options[:shell] = '/bin/bash --login'

role :app, "162.243.41.218"
role :db, "162.243.41.218", primary: true
role :web, "162.243.41.218"
role :sidekiq, "162.243.41.218"

namespace :deploy do
  desc "stub task to get cap to prompt for the root password"
  task :sudo_prompt, roles: :web do
    run "#{sudo} ls"
  end

  desc "start the app"
  task :start, roles: :web do
    run "#{sudo} monit -g hummingbird start"
  end

  desc "stop the app"
  task :stop, roles: :web do
    run "#{sudo} monit -g hummingbird stop"
  end

  desc "reload unicorn"
  task :reload_unicorn, roles: :web do
    run "kill -USR2 `cat /u/apps/hummingbird/shared/pids/unicorn.pid`"
  end

  desc "stop monit from monitoring sidekiq"
  task :stop_monit_sidekiq, roles: :sidekiq do
    run "#{sudo} monit unmonitor sidekiq"
  end

  desc "resume monit sidekiq monitoring "
  task :start_monit_sidekiq, roles: :sidekiq do
    run "#{sudo} monit monitor sidekiq"
  end

  task :copy_old_sitemap do
    run "if [ -e #{previous_release}/public/sitemap_index.xml.gz ]; then cp #{previous_release}/public/sitemap* #{current_release}/public/; fi"
  end

  task :refresh_sitemaps do
    run "cd #{latest_release} && RAILS_ENV=#{rails_env} bundle exec rake sitemap:refresh"
  end

  task :cleanup, :except => {:no_release => true} do
    count = fetch(:keep_releases, 5).to_i
    run "ls -1dt #{releases_path}/* | tail -n +#{count + 1} | #{try_sudo} xargs rm -rf"
  end
end

after "deploy:update_code", "deploy:copy_old_sitemap"

before "deploy", "deploy:sudo_prompt"

after "deploy:restart", "deploy:reload_unicorn"

before "deploy:restart", "deploy:migrate"

before "sidekiq:restart", "deploy:stop_monit_sidekiq"
after "sidekiq:restart", "deploy:start_monit_sidekiq"

after "deploy", "newrelic:notice_deployment"

# To keep only the last 5 releases:
# (Default is `set :keep_releases, 5`)
after "deploy:restart", "deploy:cleanup"
