class ProMembershipsController < ApplicationController

  before_filter :authenticate_user!

  def create
    params.permit(:token, :plan_id)

    if params[:token].blank?
      return render(text: "Didn't get credit card details from Stripe", status: 400)
    end

    if params[:plan_id].blank?
      return render(text: "No membership plan was selected", status: 400)
    end

    token, plan_id = params[:token], params[:plan_id].to_i

    begin
      plan = ProMembershipPlan.find(plan_id)
    rescue ActiveRecord::RecordNotFound
      return render(text: "No such membership plan exists", status: 400)
    end

    begin
      ProMembershipManager.new(current_user).subscribe!(plan, token)
    rescue
      return render(text: "Couldn't charge your credit card", status: 400)
    end

    render text: "subscription successful"
  end

end
