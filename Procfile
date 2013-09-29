unicorn:    bundle exec unicorn_rails -c config/unicorn.conf.rb
redis:      redis-server config/redis.conf
sidekiq:    bundle exec sidekiq -q default -q mailer -q paperclip
solr:       bundle exec rake sunspot:solr:run
beanstalkd: beanstalkd -p 11300
