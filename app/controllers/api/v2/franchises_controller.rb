module Api::V2
  class FranchisesController < ApiController
    def index
      franchises = Franchise.where(id: params[:ids])
      render json: franchises
    end

    def show
      franchise = Franchise.find(params[:id])
      render json: franchise
    end
  end
end
