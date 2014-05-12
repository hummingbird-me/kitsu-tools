class ReviewsController < ApplicationController
  def index
    respond_to do |format|
      format.html do
        @anime = Anime.find(params[:anime_id])
        preload! @anime
        render "anime/show", layout: "redesign"
      end
      format.json do
        reviews = Review.page(params[:page]).per(20).includes(:anime).includes(:user)
        if params[:anime_id]
          anime = Anime.find params[:anime_id]
          reviews = reviews.where(anime_id: anime.id).order('wilson_score DESC')
        elsif params[:user_id]
          user = User.find params[:user_id]
          reviews = reviews.where(user_id: user.id).order('created_at DESC')
        end
        render json: reviews, meta: {cursor: 1 + (params[:page] || 1).to_i}
      end
    end
  end

  def show
    @review = Review.find(params[:id])
    @anime = @review.anime

    respond_to do |format|
      format.html do
        if request.path != anime_review_path(@anime, @review)
          return redirect_to anime_review_path(@anime, @review), status: :moved_permanently
        end

        preload! @anime, serializer: FullAnimeSerializer
        preload! @review

        render "anime/show", layout: 'redesign'
      end
    end
  end

  def vote
    authenticate_user!

    @review = Review.find(params[:review_id])

    if params[:type] == "remove"
      Vote.for(current_user, @review).try(:destroy)
    else
      vote = Vote.for(current_user, @review) || Vote.new(user: current_user, target: @review)
      vote.positive = params[:type] == "up"
      vote.save
    end
    @review.reload.update_wilson_score!

    render json: true
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
