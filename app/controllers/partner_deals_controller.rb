class PartnerDealsController < ApplicationController
  before_action :authenticate_user!, only: [:update]

  def index
    deals = PartnerDeal.where(active: true).available_in(get_request_country)
    render json: deals, each_serializer: PartnerDealSerializer
  end

  # redeem a code
  def update
    unless current_user.pro?
      return head :unauthorized
    end

    deal = PartnerDeal.find(params[:id])
    # has this user redeemed a code?
    code = deal.codes.where(user: current_user).last
    if code.nil? || (deal.recurring? && Time.now > deal.recurring.seconds.since(code.claimed_at))
      deal.codes.unclaimed.limit(1).update_all(user_id: current_user.id, claimed_at: Time.now)
    end

    render json: deal, serializer: PartnerDealSerializer
  end

  private

  def get_request_country
    request.headers['CF-IPCountry']
  end
end
