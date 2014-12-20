class ProMembershipsController < ApplicationController

  before_filter :authenticate_user!

  def create
    params.permit(:token, :plan_id)

    if params[:token].blank? || params[:plan_id].blank?
      return render(text: "token/plan_id missing", status: 400)
    end

    token, plan_id = params[:token], params[:plan_id].to_i

    begin
      plan = ProMembershipPlan.find(plan_id)
    rescue ActiveRecord::RecordNotFound
      return render(text: "plan_id invalid", status: 400)
    end

    begin
      ProMembershipManager.new(current_user).subscribe!(plan, token)
    rescue
      return render(text: "subscription error", status: 400)
    end

    render text: "subscription successful"
  end

end
