#!/bin/bash

root_path="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source ${root_path}/server/.env

export REDIS_HOST=${REDIS_PORT_6379_TCP_ADDR}
export REDIS_URL=redis://${REDIS_PORT_6379_TCP_ADDR}:${REDIS_PORT_6379_TCP_PORT}/0

[ -e /usr/local/rvm/scripts/rvm  ] && \
    source /usr/local/rvm/scripts/rvm

ruby --version

[ -e ~/.nvm/nvm.sh  ] && \
    source ~/.nvm/nvm.sh

node --version

ssh-keyscan github.com >> ~/.ssh/known_hosts

pushd ${root_path}/client

bower install --allow-root
npm install

popd

export POSTGRES_HOST=${POSTGRES_PORT_5432_TCP_ADDR}
export POSTGRES_PORT=${POSTGRES_PORT_5432_TCP_PORT}
export POSTGRES_DATABASE=postgres
export POSTGRES_USERNAME=${POSTGRES_ENV_POSTGRES_USER}
export POSTGRES_PASSWORD=${POSTGRES_ENV_POSTGRES_PASSWORD}
export DATABASE_URL=postgresql://${POSTGRES_USERNAME}:${POSTGRES_PASSWORD}@${POSTGRES_HOST}:${POSTGRES_PORT}/${POSTGRES_DATABASE}

echo "Saving database credentials..."
echo "${POSTGRES_HOST}:${POSTGRES_PORT}:${POSTGRES_DATABASE}:${POSTGRES_USERNAME}:${POSTGRES_PASSWORD}" > \
  ~/.pgpass
chmod 0600 ~/.pgpass

count=$(echo "SELECT COUNT(version) FROM schema_migrations;" | \
  psql -q -d ${POSTGRES_DATABASE} -h ${POSTGRES_HOST} -p ${POSTGRES_PORT} -U ${POSTGRES_USERNAME} -w | \
  tail -n 3 | head -n 1)
status=${PIPESTATUS[0]}

[ ${status} -ne 0 ] && exit ${status}

pushd ${root_path}/server
if [ -z "${count}" ]; then
  echo "Initializing database..."
  bundle exec rake db:create db:schema:load
else
  echo "Migrating database..."
  bundle exec rake db:migrate
fi
popd

exec "$@"

