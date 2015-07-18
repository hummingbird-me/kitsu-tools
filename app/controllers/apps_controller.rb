class AppsController < ApplicationController
  before_action :authenticate_user!, only: %i(new create update mine)

  ember_action(:mine) { App.where(creator: current_user) }
  ember_action(:show, true) { App.find(params[:id]) }
  ember_action(:new)
  ember_action(:edit)

  def index
    if params[:creator]
      apps = App.where(creator: User.find(params[:creator]))
    else
      apps = {}
    end

    respond_with_ember apps
  end

  def update
    app = App.find(params[:id])

    return error! 'App not found', 404 unless app
    return error! "That's not your app", 403 unless app.creator == current_user

    app.assign_attributes(app_fields)

    save_and_render app
  end

  def create
    return error! 'Name exists', 409 if App.exists?(name: params[:name])

    app = App.create(app_fields)
    app.creator = current_user

    save_and_render app
  end

  private

  def app_fields
    permitted = %i(name homepage description logo redirect_uri)

    attrs = params.require(:app)
    attrs.delete(:logo) unless attrs[:logo] && attrs[:logo].start_with?('data:')

    attrs.permit(permitted).to_h.symbolize_keys
  end
end
