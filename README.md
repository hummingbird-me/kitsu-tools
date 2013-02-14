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

    # Load casting data.
    # Note: this import becomes much faster if you create these indexes:
    #   create unique index character_mal_id on characters (mal_id);
    #   create unique index person_mal_id on people (mal_id);
    # Be sure to get rid of them afterwards if in production.
    rake "import:casting[import/casting.json]"
    rake "import:featured_casting[import/featured_castings.json]"
    

Background tasks are processed using Sidekiq, so Redis needs to be installed.

    # Install redis
    brew install redis
    # Start the redis server
    redis-server /usr/local/etc/redis.conf
    # Start a sidekiq worker process
    bundle exec sidekiq

Switching the development database from SQLite to Postgres:

    # Step 1: Install Postgres.app from http://postgresapp.com/, and start it.

    # Step 2: Install the taps gem:
    gem install taps

    # Step 3: Create the database in Postgres by running the following:
    rake db:create:all
    rake db:schema:load

    # Step 4: Now we need to migrate the data from SQLite to Postgres, using the
    #         taps gem.
    #
    # Open a new terminal window, cd to hummingbird and run:
    taps server sqlite://db/development.sqlite3 asdf fdsaasdf
    # Next, in another terminal window, run:
    taps pull -s -e schema_migrations postgres://localhost/hummingbird_development http://asdf:fdsaasdf@localhost:5000
    # This will take some time to run, but once it is done close both terminal
    # windows.

Miscellaneous Rake Tasks:

    # Create episodes in the database.
    rake import:create_episodes

    # Post-processing age ratings.
    rake import:split_ratings
