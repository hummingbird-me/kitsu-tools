class ChatController < ApplicationController
  before_filter :authenticate_user!

  def index
    hide_cover_image
  end
  
  # Update the current user's last seen time in Redis, and return a list of
  # online users.
  def ping
    $redis.zadd("chat_last_seen", Time.now.to_i, current_user.id)
    user_ids = $redis.zrangebyscore("chat_last_seen", Time.now.to_i - 30, Time.now.to_i + 5)
    render :json => User.where(id: user_ids).map {|x| {name: x.name, url: user_url(x)} }
  end
end
