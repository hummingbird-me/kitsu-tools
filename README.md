Loading data:

    rake db:fixtures:load
    rake "import:anime_metadata[import/sample.json]"

Background tasks are processed using Sidekiq, so Redis needs to be installed.

    # Install redis
    brew install redis
    # Start the redis server
    redis-server /usr/local/etc/redis.conf
    # Start a sidekiq worker process
    bundle exec sidekiq
