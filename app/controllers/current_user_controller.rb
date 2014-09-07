class CurrentUserController < ApplicationController
  def show
    render json: current_user, serializer: CurrentUserSerializer
  end
end
