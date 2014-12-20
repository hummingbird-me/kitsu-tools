class ProMembershipsController < ApplicationController
  before_filter :authenticate_user!

  def create
    params.permit(:token, :plan_id)
    token, plan_id = params[:token], params[:plan_id].to_s
    render json: [token, plan_id].to_json
  end
end
