class ReportsController < ApplicationController
  before_action :authenticate_user!

  def index
    raise ActionController::RoutingError.new('Not Found') unless current_user.admin?

    reports = Report.where(status: :reported).page(params[:page]).per(25)

    respond_to do |format|
      format.html {
        preload_to_ember! reports
        render_ember
      }
      format.json {
        render json: reports
      }
    end
  end

  def create
    params.require(:reportable, :reason).permit(:comments)
    params[:reporter] = current_user
    report = Report.create(params)
    render json: report
  end
end
