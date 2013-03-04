class UsersController < ApplicationController
  def index
    authenticate_user!

    @status = {
      recommendations_up_to_date: current_user.recommendations_up_to_date,
      import_staging_completed: current_user.staged_import && current_user.staged_import.data[:complete]
    }
    
    respond_to do |format|
      format.html {
        flash.keep
        redirect_to '/'
      }
      format.json {
        render :json => @status
      }
    end
  end
  
  def show
    @user = User.find(params[:id])
    @active_tab = :profile
    
    @latest_reviews = @user.reviews.order('created_at DESC').limit(2)

    @anime_history = {
      recently_watched: @user.watchlists.order('last_watched DESC').limit(3).map(&:anime),
      recently_completed: @user.watchlists.where(status: "Completed").order('last_watched DESC').limit(3).map(&:anime),
      plan_to_watch: @user.watchlists.where(status: "Plan to Watch").order('updated_at DESC').limit(3).map(&:anime)
    }
  end

  def watchlist
    @user = User.find(params[:user_id])
    @active_tab = :watchlist
    @sub_tab = params[:list] || "currently_watching"
    
    if @sub_tab == "currently_watching"
      @watchlist = @user.watchlists.where(:status => "Currently Watching").order('last_watched DESC')
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
    @reviews = @user.reviews.order("created_at DESC").page(params[:page]).per(15)
  end

  def disconnect_facebook
    authenticate_user!
    current_user.update_attributes(facebook_id: nil)
    redirect_to :back
  end
end
