class ChatsController < ApplicationController
  before_filter :authenticate_user!

  def show
    render_ember
  end

  def create
    return error! "Invalid message type", 400 unless params[:type].in?(%w[message action notice])
    return error! "Message is required", 400 unless params.has_key?(:message)
    return error! "Not an administrator", 403 if params[:type] == 'notice' && !current_user.admin?
    return error! "User is banned", 403 if current_user.ninja_banned?

    MessageBus.publish "/chat/lobby", {
      id: params[:id],
      message: params[:message],
      type: params[:type] || 'message',
      formattedMessage: MessageFormatter.format_message(params[:message]),
      username: current_user.name,
      time: Time.now.iso8601(0),
      admin: current_user.admin?
    }

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
          avatar: user.avatar.url(:thumb_small),
          admin: user.admin?
        }
      end
    end

    # Get last chat message ID.
    json[:last_message_id] = MessageBus.last_id("/chat/lobby")

    render json: json
  end
end
