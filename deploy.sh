#!/bin/bash -l

# This script will update the git repository to the latest revision in the
# origin's master branch. Then it restarts sidekiq using monit and does a zero
# downtime restart of the unicorn process.

DIR=$(dirname "$0")
cd $DIR

# Update the git repo.
git fetch
git checkout master
git reset --hard HEAD@{upstream}
chown -R hummingbird:www-data .

# bundle install, precompile assets, migrate database
if [ $(whoami) = "hummingbird" ]
then
  cd $DIR && bundle install --deployment --without test
  cd $DIR && bundle exec rake assets:precompile
  cd $DIR && bundle exec rake db:migrate
  cd $DIR && cd app/frontend && npm install
  cd $DIR && cd app/frontend && bower install
else
  su - hummingbird -c "cd $DIR && bundle install --deployment --without test"
  su - hummingbird -c "cd $DIR && bundle exec rake assets:precompile"
  su - hummingbird -c "cd $DIR && bundle exec rake db:migrate"
  su - hummingbird -c "cd $DIR && cd app/frontend && npm install"
  su - hummingbird -c "cd $DIR && cd app/frontend && bower install"
fi

# restart sidekiq
monit restart sidekiq

# zero-downtime unicorn restart
kill -USR2 `cat tmp/pids/unicorn.pid`
