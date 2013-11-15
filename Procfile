unicorn:    bundle exec unicorn_rails -c config/unicorn.conf.rb
redis:      redis-server config/redis.conf
sidekiq:    bundle exec sidekiq -q default -q mailer -q paperclip
solr:       bundle exec rake sunspot:solr:run
guard:      bundle exec guard start -i
beanstalkd: beanstalkd -p 11300
