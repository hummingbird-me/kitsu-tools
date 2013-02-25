class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
    @active_tab = :profile
  end

  def watchlist
    @user = User.find(params[:user_id])
    @active_tab = :watchlist
    @sub_tab = params[:list] || "currently_watching"
    
    if @sub_tab == "currently_watching"
      @watchlist = @user.watchlists.where(:status => "Currently Watching").order('updated_at DESC')
    elsif @sub_tab == "plan_to_watch"
      @watchlist = @user.watchlists.where(:status => "Plan to Watch").page(params[:page]).per(20)
    elsif @sub_tab == "completed"
      @watchlist = @user.watchlists.where(:status => "Completed").page(params[:page]).per(20)
    elsif @sub_tab == "on_hold"
      @watchlist = @user.watchlists.where(:status => "On Hold").page(params[:page]).per(20)
    elsif @sub_tab == "dropped"
      @watchlist = @user.watchlists.where(:status => "Dropped").page(params[:page]).per(20)
    end

    render "watchlist"
  end
  
  def reviews
    @user = User.find(params[:user_id])
    @active_tab = :reviews
  end
end
