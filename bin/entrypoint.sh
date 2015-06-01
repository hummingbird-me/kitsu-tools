#!/bin/bash

root_path="$(cd "$(dirname "$(dirname "${BASH_SOURCE[0]}")")" && pwd)"

[ -e /usr/local/rvm/scripts/rvm ] && \
  source /usr/local/rvm/scripts/rvm

ruby --version

[ -e ~/.nvm/nvm.sh ] && \
  source ~/.nvm/nvm.sh

node --version

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

echo "Saving database credentials..."
echo "${POSTGRES_HOST}:${POSTGRES_PORT}:${POSTGRES_DATABASE}:${POSTGRES_USERNAME}:${POSTGRES_PASSWORD}" > \
  ~/.pgpass
chmod 0600 ~/.pgpass

count=$(echo "SELECT COUNT(version) FROM schema_migrations;" | \
  psql -q -d ${POSTGRES_DATABASE} -h ${POSTGRES_HOST} -p ${POSTGRES_PORT} -U ${POSTGRES_USERNAME} -w | \
  tail -n 3 | head -n 1)
status=${PIPESTATUS[0]}

[ ${status} -ne 0 ] && exit ${status}

if [ -z "${count}" ]; then
  echo "Initializing database..."
  bundle exec rake db:structure:load
  bundle exec rake db:seed

  echo "Load DB dump"
  curl -s https://slack-files.com/files-pub/T025CNWM0-F04TCL9QX-42e5a92d04/download/dump.sql | \
    psql -d ${POSTGRES_DATABASE} -h ${POSTGRES_HOST} -p ${POSTGRES_PORT} -U ${POSTGRES_USERNAME} -w
else
  echo "Migrating database..."
  bundle exec rake db:migrate
fi

pushd ${root_path}/frontend
./node_modules/ember-cli/bin/ember build
popd

exec "$@"

