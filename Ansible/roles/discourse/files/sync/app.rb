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
  auth_token = job_hash['auth_token']
  username = job_hash['name']
  user = User.where(auth_token: auth_token).first || User.where(username: username).first
  avatar = job_hash['new_avatar']
  new_name = job_hash['new_name']
  STDERR.puts "Started processing user #{username}."
  STDERR.puts job.body
  if user
    user.username = new_name
    user.uploaded_avatar_template = avatar
    user.save
  end
  STDERR.puts "Processed user #{username}."
  job.delete
end
