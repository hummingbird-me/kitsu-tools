class UsersController < ApplicationController
  before_filter :hide_cover_image

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
    begin
      @user = User.find(params[:id])
    rescue
      # TEMPORARY
      # Support the slug URLs as well. Remove this once it becomes a performance
      # issue.
      @user = User.all.select {|x| x.name.parameterize == params[:id] }.first
      raise ActionController::RoutingError.new('Not Found') if @user.nil?
      redirect_to @user, :status => :moved_permanently
    end

    @active_tab = :profile
    
    @latest_reviews = @user.reviews.order('created_at DESC').limit(2)

    @anime_history = {
      recently_watched: @user.watchlists.order('last_watched DESC').where("status <> 'Dropped' AND status <> 'Plan to Watch'").limit(3).map(&:anime),
      recently_completed: @user.watchlists.where(status: "Completed").order('last_watched DESC').limit(3).map(&:anime),
      plan_to_watch: @user.watchlists.where(status: "Plan to Watch").order('updated_at DESC').limit(3).map(&:anime)
    }
  end

  def watchlist
    @user = User.find(params[:user_id])
    
    respond_to do |format|
      format.html { render "watchlist", layout: "profile" }
      format.json do
        status = Watchlist.status_parameter_to_status(params[:list])
        watchlists = []
        
        if status
          watchlists = @user.watchlists.where(status: status).includes(:anime).page(params[:page]).per(50)
          # TODO simplify this sorting bit.
          if status == "Currently Watching"
            watchlists = watchlists.order('last_watched DESC')
          else
            watchlists = watchlists.order('created_at DESC')
          end
        end

        watchlists = watchlists.map do |item|
          {
            anime: {
              slug: item.anime.slug,
              url: anime_path(item.anime),
              title: item.anime.canonical_title(current_user),
              cover_image: item.anime.cover_image.url(:thumb),
              episode_count: item.anime.episode_count,
              show_type: item.anime.show_type
            },
            episodes_watched: item.episodes_watched,
            last_watched: item.last_watched,
            status: item.status,
            rating: item.rating ? item.rating+3 : "-",
            status_parameterized: item.status.parameterize,
            id: Digest::MD5.hexdigest("^_^" + item.id.to_s)
          }
        end
        
        render :json => watchlists
      end
    end
  end
  
  def reviews
    @user = User.find(params[:user_id])
    @active_tab = :reviews
    @reviews = @user.reviews.order("created_at DESC").page(params[:page]).per(15)
  end

  def forum_posts
    @user = User.find(params[:user_id])
    @posts = Forem::Post.where(user_id: @user).order('created_at DESC').page(params[:page]).per(Forem.per_page)
  end

  def disconnect_facebook
    authenticate_user!
    current_user.update_attributes(facebook_id: nil)
    redirect_to :back
  end
end
