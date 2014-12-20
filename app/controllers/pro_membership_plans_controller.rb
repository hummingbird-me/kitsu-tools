class ProMembershipPlansController < ApplicationController
  def index
    render json: ProMembershipPlan.all
  end
end
