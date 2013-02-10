class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
    @active_tab = :profile
  end

  def watchlist
    @user = User.find(params[:user_id])
    @active_tab = :watchlist
  end
  
  def reviews
    @user = User.find(params[:user_id])
    @active_tab = :reviews
  end
end
