class ReviewsController < ApplicationController
  def index
    @anime = Anime.find(params[:anime_id])
    if user_signed_in?
      @watchlist = current_user.watchlists.where(anime_id: @anime).first
    end
    @reviews = Review.includes(:user).find_with_reputation(:votes, :all, {:conditions => ["anime_id = ?", @anime.id], :order => 'votes DESC'})
    @user_evaluations = Hash.new(false)
    if user_signed_in?
      @reviews.map {|x| x.evaluations.where(source_id: current_user.id).first }.each do |evaluation|
        @user_evaluations[evaluation.target_id] = evaluation if evaluation
      end
    end
  end

  def show
    @review = Review.find(params[:id])
  end
  
  def vote
    authenticate_user!
    value = params[:type] == "up" ? 1 : 0
    @review = Review.find(params[:id])
    @review.add_or_update_evaluation(:votes, value, current_user)
    redirect_to :back
  end
end
