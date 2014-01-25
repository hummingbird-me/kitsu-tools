unicorn:    bundle exec unicorn -c config/unicorn.conf.rb
redis:      redis-server config/redis.conf
sidekiq:    bundle exec sidekiq -q default -q mailer -q paperclip
guard:      bundle exec guard start -i
beanstalkd: beanstalkd -p 11300
log:        tail -f log/development.log
