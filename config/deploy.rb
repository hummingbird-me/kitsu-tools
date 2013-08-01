require 'sidekiq/capistrano'
require 'bundler/capistrano'
require 'new_relic/recipes'

set :application, "hummingbird"
set :repository,  "git@github.com:vikhyat/hummingbird.git"

set :scm, :git
set :user, "vikhyat"
set :git_enable_submodules, 1
set :deploy_via, :remote_cache
set :sidekiq_role, :sidekiq

default_run_options[:pty] = true
default_run_options[:shell] = '/bin/bash --login'

role :app, "sheska"
role :db, "sheska", primary: true
role :web, "sheska"
role :sidekiq, "sheska"

role :web,
     "ec2-54-250-155-149.ap-northeast-1.compute.amazonaws.com",
     "ec2-54-250-153-78.ap-northeast-1.compute.amazonaws.com",
     "ec2-54-250-155-27.ap-northeast-1.compute.amazonaws.com",
     "ec2-54-250-154-200.ap-northeast-1.compute.amazonaws.com",
     "ec2-54-250-151-211.ap-northeast-1.compute.amazonaws.com"

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
  
  #namespace :assets do
  #    changes = 0
  #    begin
  #      from = source.next_revision(current_revision)
  #      changes = capture("cd #{latest_release} && #{source.local.log(from)} vendor/assets/ app/assets/ | wc -l").to_i
  #    rescue
  #      changes = 1
  #    end
  #
  #    if changes > 0
  #      run <<-CMD.compact
  #        cd -- #{latest_release} &&
  #        #{rake} RAILS_ENV=#{rails_env.to_s.shellescape} #{asset_env} assets:precompile &&
  #        cp -- #{shared_path.shellescape}/assets/manifest.yml #{current_release.shellescape}/assets_manifest.yml
  #      CMD
  #    else
  #      logger.info "Skipping asset pre-compilation because there were no asset changes"
  #    end
  #  end
  #end
  
  task :copy_old_sitemap do
    run "if [ -e #{previous_release}/public/sitemap_index.xml.gz ]; then cp #{previous_release}/public/sitemap* #{current_release}/public/; fi"
  end

  task :refresh_sitemaps do
    run "cd #{latest_release} && RAILS_ENV=#{rails_env} bundle exec rake sitemap:refresh"
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
