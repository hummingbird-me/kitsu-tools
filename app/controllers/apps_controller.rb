class AppsController < ApplicationController
  def mine
    apps = App.where(creator: current_user)
    preload_to_ember! apps
    render_ember
  end

  def index
    if params[:creator]
      apps = App.where(creator: User.find(params[:creator]))
    else
      apps = {}
    end

    respond_to do |format|
      format.json { render json: apps }
      format.html do
        render_ember
      end
    end
  end

  def show
    app = App.find(params[:id])
    app
  end

  def new
    render_ember
  end

  def create
    authenticate_user!

    return error! "Name exists", 400 if App.exists?(name: params[:name])
    app = App.create(name: params[:name], creator: current_user)
    app.save!
    render json: app
  end
end
