### Setting up a development environment on OS X

* Install Homebrew: http://brew.sh/
* Install Ruby 2.1.0 using RVM: https://rvm.io/rvm/install
* Using Homebrew, install the following:
  a. git
  b. curl
  c. v8
  d. beanstalkd
  e. redis
* Install Postgres.app: http://postgresapp.com/
* Get a database dump from Vikhyat and load it into Postgres.
* (in terminal) cat ~/Downloads/dump-.... | gzip -d | /Applications/Postgres.app/Contents/MacOS/bin/psql
* cd hummingbird && bundle install
* bundle exec foreman start

