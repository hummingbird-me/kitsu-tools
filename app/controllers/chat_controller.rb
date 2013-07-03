require 'message_formatter'

class ChatController < ApplicationController
  before_filter :authenticate_user!
  CHAT_VERSION = 15
  
  before_filter :fuck_off_demonnerd
  def fuck_off_demonnerd
    if current_user.id == 3577 or current_user.ninja_banned?
      response.headers["X-Accel-Limit-Rate"] = "300"
    end
  end

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

  def new_message
    if params[:message] and params[:message].strip.length > 0
      c = ChatMessage.create(user_id: current_user.id, message_type: "regular", message: params[:message], formatted_message: MessageFormatter.format_message(params[:message]))
      $redis.set("chat_latest_message_id", c[:"_id"])
      render :json => true
    else
      render :json => false
    end
  end
  
  def messages
    if params[:latest_chat_message_id] and $redis.get("chat_latest_message_id") == params[:latest_chat_message_id]
      render :json => []
      return
    end
    
    messages = []
    
    if params[:since]
      messages = ChatMessage.desc(:created_at).where(:created_at.gte => DateTime.parse(params[:since])).limit(100)
    elsif params[:until]
      messages = ChatMessage.desc(:created_at).where(:created_at.lte => DateTime.parse(params[:until])).limit(100)
    else
      messages = ChatMessage.desc(:created_at).limit(100)
    end
    
    # Convert Mongo model into hash.
    messages = messages.map {|x| {id: x[:"_id"], user_id: x[:user_id], type: x[:message_type], message: x.formatted_message, raw_message: x[:message], created_at: x[:created_at]} }

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
