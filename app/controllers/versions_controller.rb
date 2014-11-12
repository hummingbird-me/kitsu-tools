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
end
