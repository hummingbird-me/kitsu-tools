require 'sinatra'
require 'yaml'
require 'json'
require 'digest/md5'
require 'active_record'
require 'open-uri'

set :environment, :production

dbconf = YAML.load(File.open('/home/discourse/discourse/config/database.yml'))["production"]
ActiveRecord::Base.establish_connection(dbconf)

class User < ActiveRecord::Base
  def hummingbird_data
    JSON.load open("http://hummingbird.me/api/v1/users/#{username}")
  end
end

get '/sync' do
  SECRET = "00577b4206ac32c260897b800e0df7b44dc7bfa78dafc8d028c067e35a17d"
  username = params[:username]
  code = params[:code]
  if code == Digest::MD5.hexdigest(SECRET + username)
    user = User.find_by_username(username)
    if user
      hb_data = user.hummingbird_data
      user.uploaded_avatar_template = hb_data["avatar"]
      user.save
    end
  end
end
