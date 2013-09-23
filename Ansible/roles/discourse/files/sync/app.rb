require 'beaneater'
require 'yaml'
require 'json'
require 'active_record'

dbconf = YAML.load(File.open('/home/discourse/discourse/config/database.yml'))["production"]
ActiveRecord::Base.establish_connection(dbconf)

class User < ActiveRecord::Base
end

$beanstalk = Beaneater::Pool.new

$beanstalk.jobs.register('update-forum-avatar') do |job|
  job_hash = JSON.parse job.body
  user = User.find_by_username job_hash['name']
  avatar = job_hash['avatar']
  if user
    user.uploaded_avatar_template = avatar
    user.save
  end
end

File.open('/home/discourse/pids/sync', 'w') {|f| f.puts Process.pid }

$beanstalk.jobs.process!
