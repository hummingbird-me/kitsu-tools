require_dependency 'user_query'

class UsersController < ApplicationController
  def index
    if params[:followed_by] || params[:followers_of]
      if params[:followed_by]
        users = User.find(params[:followed_by]).following
      elsif params[:followers_of]
        users = User.find(params[:followers_of]).followers
      end
      users = users.page(params[:page]).per(20)
      UserQuery.load_is_followed(users, current_user)

      render json: users, meta: { cursor: 1 + (params[:page] || 1).to_i }
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

    # Redirect to canonical path
    if request.path != user_path(user)
      return redirect_to user_path(user), status: :moved_permanently
    end

    if user_signed_in? && current_user == user
      # Clear notifications if the current user is viewing his/her feed.
      # TODO: This needs to be moved elsewhere.
      Notification.where(user: user, notification_type: 'profile_comment',
                         seen: false).update_all seen: true
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
        action_type = 'unfollowed'
      else
        if current_user.following_count < 10_000
          user.followers.push current_user
          action_type = 'followed'
        else
          flash[:message] = "Wow! You're following 10,000 people?! You should \
                             unfollow a few people that no longer interest you \
                             before following any others."
          action_type = nil
        end
      end

      if action_type
        Substory.from_action(
          user_id: current_user.id,
          action_type: action_type,
          followed_id: user.id
        )
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
        format.json { render json: user, serializer: CurrentUserSerializer }
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
    fail ActionController::RoutingError, 'Not Found' if @user.nil?
    redirect_to @user
  end

  def comment
    authenticate_user!

    # Create the story.
    @user = User.find(params[:user_id])
    Action.broadcast(
      action_type: 'created_profile_comment',
      user: @user,
      poster: current_user,
      comment: params[:comment]
    )

    respond_to do |format|
      format.html { redirect_to :back }
      format.json { render json: true }
    end
  end

  def update
    authenticate_user!

    user = User.find(params[:id])
    changes = params[:current_user] || params[:user]

    return error!(401, 'Wrong user') unless current_user == user

    # Finagling things into place
    changes[:cover_image] =
      changes[:cover_image_url] if changes[:cover_image_url] =~ /^data:/
    changes[:password] =
      changes[:new_password] if changes[:new_password].present?
    changes[:name] = changes[:new_username] if changes[:new_username].present?
    changes[:star_rating] = (changes[:rating_type] == 'advanced')
    %i(new_password new_username rating_type cover_image_url).each do |key|
      changes.delete(key)
    end

    changes = changes.permit(:about, :location, :website, :name, :waifu_char_id,
                             :sfw_filter, :waifu, :bio, :email, :cover_image,
                             :waifu_or_husbando, :title_language_preference,
                             :password, :star_rating)

    # Convert to hash so that we ignore disallowed attributes
    user.assign_attributes(changes.to_h)

    if user.save
      render json: user
    else
      return error!(user.errors, 400)
    end
  end

  def to_follow
    fixed_user_list = %w(
      Gigguk Holden JeanP
      Arkada HappiLeeErin DoctorDazza
      Yokurama dexbonus DEMOLITION_D
    )
    @users = User.where(name: fixed_user_list)
    render json: @users, each_serializer: UserSerializer
  end

  def discourse_sso
    authenticate_user!
    payload = request.query_string
    secret = ENV['DISCOURSE_SSO_SECRET']

    # Raises an error if the signature fails verification
    sso_request = DiscourseApi::SingleSignOn.parse(payload, secret)
    sso_response = current_user.to_discourse_sso
    sso_response.nonce = sso_request.nonce
    sso_response.sso_secret = secret

    redirect_to sso_response.to_url(ENV['DISCOURSE_SSO_URL'])
  end
end
