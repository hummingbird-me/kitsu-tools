class ChatsController < ApplicationController
  before_filter :authenticate_user!

  def show
    render_ember
  end

  def create
    if params.has_key?(:message)
      MessageBus.publish "/chat", {
        message: params[:message],
        username: current_user.name
      }
    end

    render json: true
  end
end
