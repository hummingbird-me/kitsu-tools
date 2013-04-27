class ChatController < ApplicationController
  before_filter :authenticate_user!
  CHAT_VERSION = 5

  def index
    hide_cover_image
    @chat_version = CHAT_VERSION
  end
  
  # Update the current user's last seen time in Redis, and return a list of
  # online users.
  def ping
    $redis.zadd("chat_last_seen", Time.now.to_i, current_user.id)
    
    @online_users = Rails.cache.fetch(:chat_online_users, :expires_in => 4.seconds) do
      user_ids = $redis.zrangebyscore("chat_last_seen", Time.now.to_i - 30, Time.now.to_i + 5)
      User.where(id: user_ids).map {|x| {name: x.name, url: user_url(x)} }
    end

    render :json => {online_users: @online_users, chat_version: CHAT_VERSION}
  end
  
  def messages
    # If a message was posted, save it.
    if params[:message] and params[:message].strip.length > 0
      sleep 30 if current_user.id == 951
      ChatMessage.create(user_id: current_user.id, message_type: "regular", message: params[:message])
      render :json => true
    else
    
      messages = []
      
      if params[:since]
        messages = ChatMessage.desc(:created_at).where(:created_at.gte => DateTime.parse(params[:since])).limit(100)
      elsif params[:until]
        messages = ChatMessage.desc(:created_at).where(:created_at.lte => DateTime.parse(params[:until])).limit(40)
      else
        messages = ChatMessage.desc(:created_at).limit(40)
      end
      
      # Convert Mongo model into hash.
      messages = messages.map {|x| {id: x[:"_id"], user_id: x[:user_id], type: x[:message_type], message: Rinku.auto_link(ERB::Util.html_escape(x[:message]), :all, 'target="_blank"'), raw_message: x[:message], created_at: x[:created_at]} }

      # Fetch user data for each message.
      users = {}
      messages.each do |x|
        users[x[:user_id]] ||= User.find(x[:user_id])
        x[:user] = {name: users[x[:user_id]].name, url: user_url(users[x[:user_id]]), avatar: users[x[:user_id]].avatar.url(:thumb)}
      end
      
      # Sort the messages.
      messages = messages.sort_by {|x| x[:created_at] }

      render :json => messages
    end
  end
end
