class UsersController < ApplicationController
  before_filter :hide_cover_image

  def index
    if params[:followed_by] or params[:followers_of]

      if params[:followed_by]
        users = User.find(params[:followed_by]).following
      elsif params[:followers_of]
        users = User.find(params[:followers_of]).followers
      end
      users = users.page(params[:page]).per(20)

      render json: users, meta: {cursor: 1 + (params[:page] || 1).to_i}

    else
      ### OLD CODE PATH BELOW.
      authenticate_user!

      @status = {
        recommendations_up_to_date: current_user.recommendations_up_to_date
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
  end

  def show
    @user = User.find(params[:id])

    # Redirect to canonical URL if this isn't it.
    if request.path != user_path(@user)
      return redirect_to user_path(@user), status: :moved_permanently
    end

    if user_signed_in? and current_user == @user
      # Clear notifications if the current user is viewing his/her feed.
      # TODO This needs to be moved elsewhere.
      Notification.where(user: @user, notification_type: "profile_comment", seen: false).update_all seen: true
    end

    respond_to do |format|
      format.html do

        if params.has_key?(:new_feed) or Rails.env.development?
          preload! @user
          render_ember
        else
          @active_tab = :feed
          render "feed", layout: "layouts/profile"
        end

      end
      format.json { render json: @user }
    end

  end

  def followers
    user = User.find(params[:user_id])
    preload! user
    render_ember
  end

  def following
    user = User.find(params[:user_id])
    preload! user
    render_ember
  end

  def favorite_anime
    @active_tab = :favorite_anime
    @user = User.find(params[:user_id])
    @favorite_anime = @user.favorites.where(item_type: "Anime").order('id DESC').page(params[:page]).per(25)
    render "favorite_anime", layout: "layouts/profile"
  end

  def library
    @user = User.find(params[:user_id])

    # Redirect to canonical URL if this isn't it.
    if request.path != user_library_path(@user)
      return redirect_to user_library_path(@user), status: :moved_permanently
    end

    preload! @user
    render_ember
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
      format.json { render json: true }
    end
  end

  def reviews
    user = User.find(params[:user_id])
    preload! user
    render_ember
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

  def update
    authenticate_user!

    user = User.find(params[:id])

    if current_user == user
      user.about = params[:user][:about]

      if Rails.env.production? and params[:user][:cover_image_url] =~ /^data:image/
        user.cover_image = params[:user][:cover_image_url]
      end
    end

    if user.save
      render json: user
    else
      return error!(user.errors.full_messages * ', ', 500)
    end
  end
end
