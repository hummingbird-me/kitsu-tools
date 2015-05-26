#!/bin/bash

root_path="$(cd "$(dirname "$(dirname "${BASH_SOURCE[0]}")")" && pwd)"

[ -e /usr/local/rvm/scripts/rvm ] && \
  source /usr/local/rvm/scripts/rvm

ruby --version

[ -e ${root_path}/tmp/pids/unicorn.pid ] && \
  rm ${root_path}/tmp/pids/unicorn.pid

if [ ! -d ${root_path}/frontend/node_modules ]; then
  pushd ${root_path}/frontend
  npm install
  popd
fi

if [ ! -d ${root_path}/frontend/bower_components ]; then
  pushd ${root_path}/frontend
  bower --allow-root install
  popd
fi

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

pushd ${root_path}/frontend
./node_modules/ember-cli/bin/ember build
popd

exec "$@"

