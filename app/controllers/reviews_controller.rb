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
    @anime = Anime.find(params[:anime_id])
    @review = Review.find(params[:id])
    @recent_reviews = Review.order('created_at DESC').limit(10).select {|x| x.anime.sfw? }
    if user_signed_in?
      @evaluation = @review.evaluations.where(source_id: current_user.id).first
    end
  end
  
  def vote
    authenticate_user!
    value = params[:type] == "up" ? 1 : 0
    @review = Review.find(params[:id])
    @review.add_or_update_evaluation(:votes, value, current_user)
    redirect_to :back
  end
  
  def new
    authenticate_user!
    @anime = Anime.find(params[:anime_id])
    @review = Review.new
  end

  def create
    authenticate_user!

    @anime = Anime.find(params[:anime_id])
    @review = Review.new(
      user: current_user,
      anime: @anime,
      content: params["review"]["content"],
      summary: params["charcount"],
      source: "hummingbird"
    )

    @review.rating = [[1, params["review"]["rating"].to_i].max, 10].min rescue nil
    @review.rating_story      = [[1, params["review"]["rating_story"].to_i].max, 10].min rescue nil
    @review.rating_animation  = [[1, params["review"]["rating_animation"].to_i].max, 10].min rescue nil
    @review.rating_sound      = [[1, params["review"]["rating_sound"].to_i].max, 10].min rescue nil
    @review.rating_character  = [[1, params["review"]["rating_chracter"].to_i].max, 10].min rescue nil
    @review.rating_enjoyment  = [[1, params["review"]["rating_enjoyment"].to_i].max, 10].min rescue nil
    
    if @review.save
      redirect_to anime_review_path(@anime, @review)
    else
      flash[:error] = "Couldn't save your review, something went wrong."
      redirect_to :back
    end
  end
end
