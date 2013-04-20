class ChatController < ApplicationController
  before_filter :authenticate_user!

  def index

  end
  
  # Update the current user's last seen time in Redis, and return a list of
  # online users.
  def ping
    $redis.zadd("chat_last_seen", Time.now.to_i, current_user.id)
    user_ids = $redis.zrangebyscore("chat_last_seen", Time.now.to_i - 30, Time.now.to_i + 5)
    render :json => User.where(id: user_ids).map {|x| {name: x.name, url: user_url(x)} }
  end
  
  def messages
    # If a message was posted, save it.
    if params[:message] and params[:message].strip.length > 0
      ChatMessage.create(user_id: current_user.id, message_type: "regular", message: params[:message])
      render :json => true
    else
    
      messages = []
      
      if params[:since] == nil
        messages = ChatMessage.desc(:created_at).limit(100).map {|x| {id: x[:"_id"], user_id: x[:user_id], type: x[:message_type], message: x[:message], created_at: x[:created_at]} }
      end
      
      users = {}
      messages.each do |x|
        users[x[:user_id]] ||= User.find(x[:user_id])
        x[:user] = {name: users[x[:user_id]].name, url: user_url(users[x[:user_id]]), avatar: users[x[:user_id]].avatar.url(:thumb)}
      end
      messages = messages.sort_by {|x| x[:created_at] }
      render :json => messages
      
    end
  end
end
