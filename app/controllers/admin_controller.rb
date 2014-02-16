class AdminController < ApplicationController

  before_filter :allow_only_admins
  def allow_only_admins
    # This shouldn't be needed becuse we also check for admin-ness in the 
    # routes. Still doing this just to be safe. 
    authenticate_user!
    if not current_user.admin?
      raise ActionController::RoutingError.new('Not Found')
    end
  end

  def find_or_create_by_mal
    @anime = Anime.find_by_mal_id params[:mal_id]
    if @anime.nil?
      @anime = Anime.create title: params[:mal_id], mal_id: params[:mal_id]
    end
    @anime.get_metadata_from_mal
    redirect_to @anime
  end

  def invite_to_beta
    email = params[:email]
    inv = BetaInvite.find_or_create_by_email(email)
    inv.invite!
    flash[:success] = "Invited #{email}."
    redirect_to :back
  end

  def index
    @total_beta   = BetaInvite.count
    @invited_beta = BetaInvite.where(invited: true).count
    @user_count   = User.count

    @anime_without_mal_id = Anime.where(mal_id: nil)

    @hide_cover_image = true
    @hide_footer_ad = true
  end

  def login_as_user
    user = User.find(params[:user_id].strip.downcase)
    sign_in(:user, user)
    redirect_to "/"
  end

  def stats
  end
end
