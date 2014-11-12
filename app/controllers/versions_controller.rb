class VersionsController < ApplicationController
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
    render json: true
  end

  def destroy
    Version.find(params[:id]).destroy
    render json: true
  end
end
