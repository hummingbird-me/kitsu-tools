class VersionsController < ApplicationController
  before_action :limit_to_staff

  def index
    state = params[:state] || :pending
    versions = Version.where('state = ?', Version.states[state])

    respond_to do |format|
      format.html {
        # todo: preload ember
        render_ember
      }
      format.json {
        render json: versions, each_serializer: VersionSerializer
      }
    end
  end

  def show
    # todo: preload ember
    version = Version.find(params[:id])
    respond_to do |format|
      format.html { render_ember }
      format.json { render json: version, serializer: VersionSerializer }
    end
  end

  def update
    version = Version.find(params[:id])
    version.item.update_from_pending(version)
    version.user.increment!(:approved_edit_count)
    render json: true
  end

  def destroy
    version = Version.find(params[:id]).destroy
    version.user.increment!(:rejected_edit_count)
    render json: true
  end

  private

  # limit to staff members until user trust is implemented
  def limit_to_staff
    authenticate_user!
    unless current_user.admin?
      raise ActionController::RoutingError.new('Not Found')
    end
  end
end
