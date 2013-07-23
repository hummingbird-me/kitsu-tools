
class ReviewsController < ApplicationController
  def full_index
    # TODO
  end

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
    TrendingReview.vote @review.id if value == 1
    redirect_to :back
  end
  
  def new
    authenticate_user!
    @anime = Anime.find(params[:anime_id])
    if Review.exists?(user_id: current_user, anime_id: @anime)
      @review = Review.find_by_user_id_and_anime_id(current_user.id, @anime.id)
      redirect_to edit_anime_review_path(@anime, @review)
    else
      @review = Review.new(user: current_user)
    end
  end

  def create
    authenticate_user!
    
    @anime = Anime.find(params[:anime_id])
    @review = Review.find_by_user_id_and_anime_id(current_user.id, @anime.id)
    if @review.nil?
      @review = Review.new(user: current_user, anime: @anime)
    end
    
    @review.content = params["review"]["content"]
    @review.summary = params["review"]["summary"]
    @review.summary = nil if @review.summary.strip.length == 0
    @review.source  = "hummingbird"

    @review.rating = [[1, params["review"]["rating"].to_i].max, 10].min rescue nil
    @review.rating_story      = [[1, params["review"]["rating_story"].to_i].max, 10].min rescue nil
    @review.rating_animation  = [[1, params["review"]["rating_animation"].to_i].max, 10].min rescue nil
    @review.rating_sound      = [[1, params["review"]["rating_sound"].to_i].max, 10].min rescue nil
    @review.rating_character  = [[1, params["review"]["rating_character"].to_i].max, 10].min rescue nil
    @review.rating_enjoyment  = [[1, params["review"]["rating_enjoyment"].to_i].max, 10].min rescue nil
    
    if @review.save
      redirect_to anime_review_path(@anime, @review)
    else
      flash[:error] = "Couldn't save your review, something went wrong."
      redirect_to :back
    end
  end

  def edit
    authenticate_user!
    @anime  = Anime.find(params[:anime_id])
    @review = Review.find(params[:id])
    if @review.user != current_user
      flash[:error] = "You are not authorized to edit this review."
      redirect_to :back
    else
      # Logic
    end
  end
  
  def update
    create
  end
end
