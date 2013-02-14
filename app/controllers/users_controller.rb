class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
    @active_tab = :profile
  end

  def watchlist
    @user = User.find(params[:user_id])
    @active_tab = :watchlist
    if params[:list]
      if params[:list] == "plan_to_watch"
        render "watchlist_plan_to_watch"
      elsif params[:list] == "completed"
        render "watchlist_completed"
      elsif params[:list] == "on_hold"
        render "watchlist_on_hold"
      elsif params[:list] == "dropped"
        render "dropped"
      else
        # Currently watchlist
        render "watchlist"
      end
    end
  end
  
  def reviews
    @user = User.find(params[:user_id])
    @active_tab = :reviews
  end
end
