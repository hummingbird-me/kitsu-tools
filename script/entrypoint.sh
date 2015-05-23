#!/bin/bash

source /usr/local/rvm/scripts/rvm

ruby --version

[ -e /opt/hummingbird/tmp/pids/unicorn.pid ] && \
  rm /opt/hummingbird/tmp/pids/unicorn.pid

if [ ! -d /opt/hummingbird/frontend/node_modules ]; then
  pushd /opt/hummingbird/frontend
  npm install
  popd
fi

if [ ! -d /opt/hummingbird/frontend/bower_components ]; then
  pushd /opt/hummingbird/frontend
  bower --allow-root install
  popd
fi

export REDIS_HOST=${REDIS_PORT_6379_TCP_ADDR}
export REDIS_URL=redis://${REDIS_PORT_6379_TCP_ADDR}:${REDIS_PORT_6379_TCP_PORT}/0

export POSTGRES_HOST=${POSTGRES_PORT_5432_TCP_ADDR}
export POSTGRES_PORT=${POSTGRES_PORT_5432_TCP_PORT}
export POSTGRES_DATABASE=postgres
export POSTGRES_USERNAME=${POSTGRES_ENV_POSTGRES_USER}
export POSTGRES_PASSWORD=${POSTGRES_ENV_POSTGRES_PASSWORD}

#echo "Creating database..."
#bundle exec rake db:create
echo "Initializing database..."
bundle exec rake db:structure:load
bundle exec rake db:seed

echo "Migrating database..."
bundle exec rake db:migrate

pushd /opt/hummingbird/frontend
./node_modules/ember-cli/bin/ember build
popd

exec "$@"

