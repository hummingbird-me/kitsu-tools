require_dependency 'user_query'

class UsersController < ApplicationController
  before_action :canonicalize_url

  def index
    if params[:followed_by] || params[:followers_of]
      if params[:followed_by]
        users = User.find(params[:followed_by]).following
      elsif params[:followers_of]
        users = User.find(params[:followers_of]).followers
      end
      users = users.page(params[:page]).per(20)
      UserQuery.load_is_followed(users, current_user)

      render json: users, meta: {cursor: 1 + (params[:page] || 1).to_i}
    elsif params[:to_follow]
      render json: User.where(to_follow: true), each_serializer: UserSerializer
    else
      ### OLD CODE PATH BELOW. Used only by the recommendations page.
      authenticate_user!

      status = {
        recommendations_up_to_date: current_user.recommendations_up_to_date
      }

      respond_to do |format|
        format.html { redirect_to '/' }
        format.json { render json: status }
      end
    end
  end

  def show
    user = User.find(params[:id])

    if user_signed_in? and current_user == user
      # Clear notifications if the current user is viewing his/her feed.
      # TODO This needs to be moved elsewhere.
      Notification.where(user: user, notification_type: "profile_comment", seen: false).update_all seen: true
    end

    respond_with_ember user
  end

  ember_action(:ember) { User.find(params[:user_id]) }

  def follow
    authenticate_user!
    user = User.find(params[:user_id])

    if user != current_user
      if user.followers.include? current_user
        user.followers.destroy current_user
        action_type = "unfollowed"
      else
        if current_user.following_count < 10000
          user.followers.push current_user
          action_type = "followed"
        else
          flash[:message] = "Wow! You're following 10,000 people?! You should unfollow a few people that no longer interest you before following any others."
          action_type = nil
        end
      end

      if action_type
        Substory.from_action({
          user_id: current_user.id,
          action_type: action_type,
          followed_id: user.id
        })
      end
    end

    respond_to do |format|
      format.html { redirect_to :back }
      format.json { render json: true }
    end
  end

  def update_avatar
    authenticate_user!

    user = User.find(params[:user_id])
    if user == current_user
      user.avatar = params[:avatar] || params[:user][:avatar]
      user.save!
      respond_to do |format|
        format.html { redirect_to :back }
        format.json { render json: user,
                             serializer: CurrentUserSerializer }
      end
    else
      error! 403
    end
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
      format.json { render :json => true }
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

  def update
    authenticate_user!

    user = User.find(params[:id])
    changes = params[:current_user] || params[:user]

    if current_user == user
      user.about = changes[:about] || ""
      user.location = changes[:location]
      user.waifu = changes[:waifu]
      user.website = changes[:website]
      user.waifu_or_husbando = changes[:waifu_or_husbando]
      user.bio = changes[:bio] || ""
      user.waifu_char_id = changes[:waifu_char_id]

      if changes[:cover_image_url] =~ /^data:image/
        user.cover_image = changes[:cover_image_url]
      end

      # Settings page stuff
      if params[:current_user]
        user.email = changes[:email]
        user.password = changes[:new_password] unless changes[:new_password].blank?
        user.name = changes[:new_username] unless changes[:new_username].blank?
        user.star_rating = (changes[:rating_type] == 'advanced')
        user.sfw_filter = changes[:sfw_filter]
        user.title_language_preference = changes[:title_language_preference]
      end
    end

    if user.save
      render json: user
    else
      return error!(user.errors.full_messages * ', ', 500)
    end
  end

  def to_follow
    fixedUserList = [
      'Gigguk', 'Holden', 'JeanP',
      'Arkada', 'HappiLeeErin', 'DoctorDazza',
      'Yokurama', 'dexbonus', 'DEMOLITION_D'
    ]
    @users = User.where(:name => fixedUserList)
    render json: @users, each_serializer: UserSerializer
  end
end
