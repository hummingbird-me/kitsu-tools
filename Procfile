puma:     bundle exec puma -C config/puma.rb
redis:    redis-server config/redis.conf
sidekiq:  bundle exec sidekiq -q default -q mailer
mongo:    mongod
solr:     bundle exec rake sunspot:solr:run
