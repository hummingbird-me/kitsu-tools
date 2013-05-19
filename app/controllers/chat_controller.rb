class ChatController < ApplicationController
  before_filter :authenticate_user!
  CHAT_VERSION = 13

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

  # Helper method. Takes raw message -> outputs HTML.
  def format_message(message)
    formatted = Rinku.auto_link(ERB::Util.html_escape(message), :all, 'target="_blank"')
    
    # Link @usernames.
    formatted = formatted.gsub(/@[-_A-Za-z0-9]+/) do |x|
      u = User.find_by_name(x[1..-1])
      if u
        "<span class='name'>@<a href='#{user_url(u)}' target='_blank' data-user-name='#{u.name}'>#{u.name}</a></span>"
      else
        x
      end
    end
    
    noko = Nokogiri::HTML.parse formatted
    links = noko.css('a').map {|link| link['href'] }
    if links.length > 0
      link = links[-1]
      
      # Embed images.
      if link =~ /\.(gif|jpe?g|png)$/i
        begin
          if open(link).size <= 1024*1024
            formatted += "<br><img class='autoembed' src='#{link}' style='max-height: 200px; width: auto; max-width: 600'>"
          end
        rescue
        end
      end
      
      # Embed YouTube videos.
      if link =~ /(?:http:\/\/)?(?:www\.)?(?:youtube\.com|youtu\.be)\/(?:watch\?v=)?(.+)/
        code = link.scan(/v=([A-Za-z0-9\-_]+)/)[0][0]
        formatted += "<br><iframe width='350' height='240' frameborder='0' class='autoembed' allowfullscreen src='http://youtube.com/embed/#{code}' />"
      end
    end
    
    formatted
  end
  
  def messages
    # If a message was posted, save it.
    if params[:message] and params[:message].strip.length > 0
      sleep 30 if current_user.id == 951
      ChatMessage.create(user_id: current_user.id, message_type: "regular", message: params[:message], formatted_message: format_message(params[:message]))
      render :json => true
    else
    
      messages = []
      
      if params[:since]
        messages = ChatMessage.desc(:created_at).where(:created_at.gte => DateTime.parse(params[:since])).limit(100)
      elsif params[:until]
        messages = ChatMessage.desc(:created_at).where(:created_at.lte => DateTime.parse(params[:until])).limit(100)
      else
        messages = ChatMessage.desc(:created_at).limit(100)
      end
      
      # Format any unformatted messages.
      messages.each do |x|
        if x.formatted_message.nil?
          x.formatted_message = format_message x[:message]
          x.save
        end
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
end
