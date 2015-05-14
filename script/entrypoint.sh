#!/bin/bash

source /usr/local/rvm/scripts/rvm

ruby --version

[ -e /opt/hummingbird/tmp/pids/unicorn.pid ] && \
  rm /opt/hummingbird/tmp/pids/unicorn.pid

sed -i 's/^REDIS_HOST=.*/REDIS_HOST=${REDIS_PORT_6379_TCP_ADDR}/' /opt/hummingbird/.env
sed -i 's#^REDIS_URL=.*#REDIS_URL=redis://${REDIS_PORT_6379_TCP_ADDR}:${REDIS_PORT_6379_TCP_PORT}/0#' /opt/hummingbird/.env

#bundle exec rake db:create db:structure:load db:seed

exec "$@"

