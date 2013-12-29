module Api::V2
  class ReviewsController < ApiController
    def index
      reviews = Review.where(id: params[:ids])
      render json: reviews
    end
  end
end
