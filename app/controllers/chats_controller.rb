class ChatsController < ApplicationController
  before_filter :authenticate_user!

  def show
    render_ember
  end

  def create
    if params.has_key?(:message) && !current_user.ninja_banned?
      #Note: MessageBus.backlog("/chat/lobby", params[:id])[0]["data"]["username"] = User who wrote the message originally
      #This doesn't seem very efficient. Please change this if you have a better idea
      msgs = MessageBus.backlog("/chat/lobby", MessageBus.last_id("/chat/lobby")-40)
      msgs.each { |msg| return error! "Message id already used", 403 unless msg["data"]["id"]!=params[:id] }
      MessageBus.publish "/chat/lobby", {
        id: params[:id],
        message: params[:message],
        formattedMessage: MessageFormatter.format_message(params[:message]),
        username: current_user.name,
        time: Time.now.iso8601(0),
        admin: current_user.admin?
      }
    end

    render json: true
  end

  def destroy
    return error! "Not administrator", 403 unless current_user.admin?
    return error! "Needs id to delete", 400 unless params.has_key?(:id)

    MessageBus.publish "/chat/lobby", {
      type: "delete",
      id: params[:id],
      username: current_user.name,
      time: Time.now.iso8601(0)
    }
    render json: true
  end

  def ping
    json = {}

    # Get online users.
    $redis.with do |conn|
      time = Time.now.to_i
      conn.zadd "chat_online", time, current_user.id
      active_user_ids = conn.zrangebyscore "chat_online", time-60, "+inf"
      active_users = User.where(id: active_user_ids).order(:id)
      json[:online_users] = active_users.map do |user|
        {
          username: user.name,
          avatar: user.avatar.url(:thumb_small)
        }
      end
    end

    # Get last chat message ID.
    json[:last_message_id] = MessageBus.last_id("/chat/lobby")

    render json: json
  end
end
