class FranchisesController < ApplicationController
  def index
    franchises = Franchise.where(id: params[:ids]).includes(anime: :genres)
    render json: franchises
  end

  def show
    franchise = Franchise.find(params[:id])
    render json: franchise
  end
end
