require_dependency 'mal_import'

class AdminController < ApplicationController
  before_action :allow_only_admins

  def allow_only_admins
    # This shouldn't be needed becuse we also check for admin-ness in the
    # routes. Still doing this just to be safe.
    authenticate_user!

    fail ActionController::RoutingError, 'Not Found' unless current_user.admin?
  end

  def find_or_create_by_mal
    media = params[:media].to_sym
    mal = MALImport.new(media, params[:mal_id].to_i, :shallow)
    @thing = case media
             when :anime
               Anime.create_or_update_from_hash mal.to_h
             when :manga
               Manga.create_or_update_from_hash mal.to_h
    end
    redirect_to @thing
    MyAnimeListScrapeWorker.perform_async(media, params[:mal_id].to_i)
  end

  def index
    @anime_without_mal_id = Anime.where(mal_id: nil).where.not(
      id: Anime.select(:id)
               .joins(:genres)
               .where(genres: { name: 'Anime Influenced' })
    )
    # Sort by partner code count (ascending) where there's less than 20 left
    @deals = PartnerDeal
             .joins(
               'LEFT JOIN partner_codes
                ON partner_codes.partner_deal_id = partner_deals.id'
             )
             .select(
               'partner_deals.*, count(partner_codes.id) AS codes_remaining'
             )
             .group('partner_deals.id')
             .having('count(partner_codes.id) < 20')
             .order('count(partner_codes.id) asc')
    @blotter = Blotter.get

    generic_preload! 'nonmal_anime', @anime_without_mal_id		
    generic_preload! 'blotter', @blotter		
    generic_preload! 'deals_to_refill', @deals		

    render_ember		
  end

  def login_as_user
    user = User.find(params[:user_id].strip.downcase)
    sign_in(:user, user)
    redirect_to '/'
  end

  def stats
    stats = {}

    stats[:activeaccs] = User.where('last_library_update >= ?', 1.day.ago).count
    stats[:feedposts] = Story.where('created_at >= ?', 1.day.ago).count
    stats[:feedcomments] = Substory.where('created_at >= ?', 1.day.ago).count
    stats[:feedlikes] = Vote.where(target_type: 'Story')
                        .where('created_at >= ?', 1.day.ago).count
    stats[:groupjoins] = GroupMember.accepted
                         .where('created_at >= ?', 1.day.ago).count
    stats[:pending_count] = Version.pending.count
    stats[:sha_hash] = `git log --pretty=format:'%h' -n 1`

    stats[:registrations] = { total: {}, confirmed: {} }
    User.where('created_at >= ?', 1.week.ago).find_each do |user|
      daysago = user.created_at.strftime('%b %d')
      stats[:registrations][:total][daysago] ||= 0
      stats[:registrations][:confirmed][daysago] ||= 0

      stats[:registrations][:total][daysago] += 1
      stats[:registrations][:confirmed][daysago] += 1 if user.confirmed?
    end
    firstkey = stats[:registrations][:total].keys.sort.first
    stats[:registrations][:total].delete firstkey
    stats[:registrations][:confirmed].delete firstkey

    render json: stats
  end

  def users_to_follow
    @users_to_follow = User.where(to_follow: true)
  end

  def users_to_follow_submit
    user = User.find(params[:user_id])
    to_follow = params[:to_follow]
    user.to_follow = to_follow
    user.save
    redirect_to '/kotodama'
  end

  def blotter_set
    Blotter.set(
      icon: params[:icon],
      message: params[:message],
      link: params[:link]
    )
    redirect_to '/kotodama'
  end

  def blotter_clear
    Blotter.clear
    redirect_to '/kotodama'
  end

  def deploy
    if Rails.env.production?
      Thread.new do
        system '/var/hummingbird/deploy.sh',
               current_user.name,
               current_user.avatar.to_s(:small)
      end
      render text: 'Deployed maybe'
    else
      render text: 'Can only deploy in production.'
    end
  end

  def publish_update
    MessageBus.publish '/site_update', {}
  end

  def reset_break_counter
    $redis.with { |conn| conn.set('break_counter', Time.now.to_i) }
    render json: true
  end

  def refill_codes
    if params[:codes] && params[:deal_id]
      ActiveRecord::Base.transaction do
        params[:codes].tempfile.each_line do |line|
          PartnerCode.create!(
            partner_deal_id: params[:deal_id],
            code: line.strip
          )
        end
      end
      render json: true
    else
      render json: false
    end
  end
end
