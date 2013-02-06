Loading data:

    # Load the fixtures
    rake db:fixtures:load

    # Next, run either one of the following alternatives depending on what you
    # want to happen.

    # Load a subset of data imported from MAL:
    cat import/full_db.json | head -n 300 > import/sample.json
    rake "import:anime_metadata[import/sample.json]"

    # Load all of the data.
    rake "import:anime_metadata[import/full_db.json]"
    

Background tasks are processed using Sidekiq, so Redis needs to be installed.

    # Install redis
    brew install redis
    # Start the redis server
    redis-server /usr/local/etc/redis.conf
    # Start a sidekiq worker process
    bundle exec sidekiq
