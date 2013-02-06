class ReviewsController < ApplicationController
  def index
    @anime = Anime.find(params[:anime_id])
    @reviews = Review.includes(:user).find_with_reputation(:votes, :all, {:conditions => ["anime_id = ?", @anime.id], :order => 'votes DESC'})
  end
  
  def vote
    authenticate_user!
    value = params[:type] == "up" ? 1 : 0
    @review = Review.find(params[:id])
    @review.add_or_update_evaluation(:votes, value, current_user)
    redirect_to :back
  end
end
