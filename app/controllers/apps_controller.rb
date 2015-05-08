class AppsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :update, :mine]

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

  def show
    app = App.find(params[:id])
    app
  end

    save_and_render app
  end

  def create
    authenticate_user!

    return error! "Name exists", 400 if App.exists?(name: params[:name])
    app = App.create(name: params[:name], creator: current_user)
    app.save!
    render json: app
  end
end
