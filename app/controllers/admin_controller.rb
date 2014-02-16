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
    @anime_without_mal_id = Anime.where(mal_id: nil).reject {|x| x.genres.map(&:name).include? "Anime Influenced" }

    @hide_cover_image = true
    @hide_footer_ad = true
  end

  def login_as_user
    user = User.find(params[:user_id].strip.downcase)
    sign_in(:user, user)
    redirect_to "/"
  end

  def stats
    stats = {}

    stats[:registrations] = {total: {}, confirmed: {}}

    User.where('created_at >= ?', 1.week.ago).find_each do |user|
      daysago = ((Time.now - user.created_at) / (3600*24)).to_i
      stats[:registrations][:total][daysago] ||= 0
      stats[:registrations][:confirmed][daysago] ||= 0

      stats[:registrations][:total][daysago] += 1
      stats[:registrations][:confirmed][daysago] += 1 if user.confirmed?
    end

    render json: stats
  end
end
