#!/bin/bash -l

# This script will update the git repository to the latest revision in the
# origin's master branch. Then it restarts sidekiq using monit and does a zero
# downtime restart of the unicorn process.
#
# It is intended to be run by Travis after a successful build.

DIR=$(dirname "$0")
cd $DIR

# Update the git repo.
git fetch
git checkout master
git reset --hard HEAD@{upstream}
chown -R hummingbird:www-data .

# bundle install, precompile assets, migrate database
su - hummingbird -c "cd $DIR && bundle install --deployment --without test"
su - hummingbird -c "cd $DIR && bundle exec rake assets:precompile"
su - hummingbird -c "cd $DIR && bundle exec rake db:migrate"

# restart sidekiq
monit restart sidekiq

# zero-downtime unicorn restart
kill -USR2 `cat tmp/pids/unicorn.pid`
