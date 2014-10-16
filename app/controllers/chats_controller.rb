class ChatsController < ApplicationController
  before_filter :authenticate_user!

  def show
    render_ember
  end

  def create
    if params.has_key?(:message)
      MessageBus.publish "/chat", {
        id: params[:id],
        message: params[:message],
        formatted_message: MessageFormatter.format_message(params[:message]),
        username: current_user.name,
        delivered: true
      }
    end

    render json: true
  end
end
