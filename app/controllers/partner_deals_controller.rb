class PartnerDealsController < ApplicationController
  before_action :authenticate_user!, only: [:update]

  def index
    # todo: return only deals available in users country
    # todo: return deals with codes available
    render json: PartnerDeal.where(active: true),
      each_serializer: PartnerDealSerializer
  end

  # redeem a code
  def update
    params.permit(:user_id)

    unless current_user.pro?
      return head :unauthorized
    end

    deal = PartnerDeal.find(params[:id])
    # has this user redeemed a code?
    code = deal.codes.find_by(user: current_user)
    if code.nil?
      # todo: deal with potential race condition
      code = deal.codes.unclaimed.first
      code.update_attributes!(user: current_user, claimed_at: DateTime.now)
    else
      # todo: deal with monthly based codes
    end

    # output the redeemed code
    render text: code.code unless code.nil?
  end
end
