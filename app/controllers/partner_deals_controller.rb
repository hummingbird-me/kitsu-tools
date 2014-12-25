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
    if code.nil? || (deal.recurring? && Time.now > 1.month.since(code.claimed_at))
      code = deal.codes.unclaimed.first
      code.update_attributes!(user: current_user, claimed_at: Time.now)
    end

    render json: deal, serializer: PartnerDealSerializer
  end

  private

  def get_request_country
    request.headers['CF-IPCountry']
  end
end
