class VersionsController < ApplicationController
  before_action :limit_to_staff

  def index
    state = params[:state] || :pending
    versions = Version.where('state = ?', Version.states[state])
      .page(params[:page]).per(10)

    respond_to do |format|
      format.html {
        generic_preload! "versions", ed_serialize(versions)
        render_ember
      }
      format.json {
        render json: versions, each_serializer: VersionSerializer,
          meta: { cursor: 1 + (params[:page] || 1).to_i }
      }
    end
  end

  def update
    version = Version.find(params[:id])
    # update state to history outside of the background job
    version.update_attribute(:state, :history)
    VersionWorker.perform_async(version.id)

    User.increment_counter(:approved_edit_count, version.user_id)
    render json: true
  end

  def destroy
    version = Version.find(params[:id]).destroy
    User.increment_counter(:rejected_edit_count, version.user_id)
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
