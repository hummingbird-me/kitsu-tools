class UsersController < ApplicationController
  before_filter :hide_cover_image

  def unsubscribe
    unsub_type = params[:unsub_type]
    hash = params[:hash]
    user = User.all.select {|x| x.encrypted_email == hash }.first
    user.update_column :subscribed_to_newsletter, false
    flash[:notice] = "Successfully unsubscribed #{user.email}."
    redirect_to '/'
  end

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
      return
    end

    redirect_to user_feed_path(@user)
    return

    @active_tab = :profile

    @latest_reviews = @user.reviews.order('created_at DESC').limit(2)

    @anime_history = {
      recently_watched: @user.watchlists.order('last_watched DESC').where("status <> 'Dropped' AND status <> 'Plan to Watch'").limit(3).map(&:anime),
      recently_completed: @user.watchlists.where(status: "Completed").order('last_watched DESC').limit(3).map(&:anime),
      plan_to_watch: @user.watchlists.where(status: "Plan to Watch").order('updated_at DESC').limit(3).map(&:anime)
    }
  end

  def followers
    @active_tab = :followers
    @user = User.find(params[:user_id])
    @results = @user.followers.page(params[:page]).per(20)
    render "followers_following", layout: "layouts/profile"
  end

  def favorite_anime
    @active_tab = :favorite_anime
    @user = User.find(params[:user_id])
    @favorite_anime = @user.favorites.where(item_type: "Anime").order('id DESC').page(params[:page]).per(25)
    render "favorite_anime", layout: "layouts/profile"
  end
  
  def following
    @active_tab = :following
    @user = User.find(params[:user_id])
    @results = @user.following.page(params[:page]).per(20)
    render "followers_following", layout: "layouts/profile"
  end

  def watchlist
    @active_tab = :library
    @user = User.find(params[:user_id])
    render :library, layout: 'profile'
  end

  def follow
    authenticate_user!
    @user = User.find(params[:user_id])

    if @user != current_user
      if @user.followers.include? current_user
        @user.followers.destroy current_user
        action_type = "unfollowed"
      else
        if current_user.following_count < 2000
          @user.followers.push current_user
          action_type = "followed"
        else
          flash[:message] = "Wow! You're following 2,000 people?! You should unfollow a few people that no longer interest you before following any others."
          action_type = nil
        end
      end

      if action_type
        Substory.from_action({
          user_id: current_user.id,
          action_type: action_type,
          followed_id: @user.id
        })
      end
    end

    respond_to do |format|
      format.html { redirect_to :back }
    end
  end

  def feed
    @active_tab = :feed
    @user = User.find(params[:user_id])
    render "feed", layout: "layouts/profile"
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

  def update_cover_image
    @user = User.find(params[:user_id])
    authorize! :update, @user
    if params[:user][:cover_image]
      @user.cover_image = params[:user][:cover_image]
      flash[:success] = "Cover image updated successfully." if @user.save
    end
    redirect_to :back
  end

  def update_avatar
    @user = User.find(params[:user_id])
    authorize! :update, @user
    if params[:user] and params[:user][:avatar]
      @user.avatar = params[:user][:avatar]
      flash[:success] = "Avatar updated successfully." if @user.save
    end
    redirect_to :back
  end

  def disconnect_facebook
    authenticate_user!
    current_user.update_attributes(facebook_id: nil)
    redirect_to :back
  end

  def redirect_short_url
    @user = User.find_by_name params[:username]
    raise ActionController::RoutingError.new('Not Found') if @user.nil?
    redirect_to @user
  end
  
  def comment
    authenticate_user!

    # Create the story.
    @user = User.find(params[:user_id])
    story = Action.broadcast(
      action_type: "created_profile_comment",
      user: @user,
      poster: current_user,
      comment: params[:comment]
    )

    respond_to do |format|
      format.html { redirect_to :back }
      format.json { render :json => Entities::Story.represent(story) }
    end
  end

  def toggle_connection
    authenticate_user!

    if params[:connection] == "neonalley"
      if params[:enable]
        current_user.neon_alley_integration = true
      elsif params[:disable]
        current_user.neon_alley_integration = false
      end
      current_user.save
    end
    
    respond_to do |format|
      format.html { redirect_to :back }
    end
  end

  def update_setting
    authenticate_user!

    if params[:rating_system]
      if params[:rating_system] == "simple"
        current_user.star_rating = false
      elsif params[:rating_system] == "advanced"
        current_user.star_rating = true
      end
    end

    if current_user.save
      render :json => true
    else
      render :json => false
    end
  end

  def cover_image
    user = User.find_by_name(params[:user_id]) || not_found!
    redirect_to user.cover_image.url(:thumb)
  end

  def trigger_forum_sync
    username = params[:user_id]
    secret   = params[:secret]
    if secret == "topsecretsecret"
      User.find(username).sync_to_forum!
      render :json => true
    else
      render :json => false
    end
  end
end
