class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
    @active_tab = :profile
  end
end
