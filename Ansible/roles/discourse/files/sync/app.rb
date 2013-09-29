require 'beaneater'
require 'yaml'
require 'json'
require 'active_record'

File.open('/home/discourse/pids/sync', 'w') {|f| f.puts Process.pid }

dbconf = YAML.load(File.open('/home/discourse/discourse/config/database.yml'))["production"]
ActiveRecord::Base.establish_connection(dbconf)

class User < ActiveRecord::Base
end

$beanstalk = Beaneater::Pool.new
$beanstalk.tubes.watch!('update-forum-account')

loop do
  job = $beanstalk.tubes.reserve
  job_hash = JSON.parse job.body
  username = job_hash['name']
  user = User.find_by_username username
  avatar = job_hash['new_avatar']
  STDERR.puts "Started processing user #{username}."
  if user
    user.uploaded_avatar_template = avatar
    user.save
  end
  STDERR.puts "Processed user #{username}."
  job.delete
end

