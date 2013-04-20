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
    if params[:message]
      ChatMessage.create(user_id: current_user.id, message_type: "regular", message: params[:message])
    end
    
    messages = []
    
    if params[:since] == nil
      messages = ChatMessage.desc(:created_at).limit(100).map {|x| {user: x[:user_id], type: x[:message_type], message: x[:message], created_at: x[:created_at]} }
    end
    
    users = {}
    messages.each do |x|
      users[x] ||= User.find(x[:user])
      x[:user] = {name: users[x].name, url: user_url(users[x]), avatar: users[x].avatar.url(:thumb)}
    end
    messages = messages.sort_by {|x| x[:created_at] }.reverse
    render :json => messages
  end
end
