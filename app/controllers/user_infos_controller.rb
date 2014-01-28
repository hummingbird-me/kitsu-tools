class UserInfosController < ApplicationController
  def show
    user = User.find(params[:id])
    render json: user, serializer: UserInfoSerializer
  end
end
