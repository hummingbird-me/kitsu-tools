class AnimeSerializer < ActiveModel::Serializer
  embed :ids, include: true

  attributes :id, :canonical_title, :synopsis, :cover_image, :cover_image_top_offset, :poster_image, :genres, :show_type, :age_rating, :age_rating_guide, :episode_count, :episode_length, :started_airing, :finished_airing, :screencaps, :languages, :community_ratings, :youtube_video_id, :is_favorite, :library_status, :bayesian_rating

  has_many :featured_quotes, root: :quotes
  has_many :trending_reviews, root: :reviews
  has_many :featured_castings, root: :castings
  has_many :producers, embed_key: :slug
  has_many :franchises, include: false

  def id
    object.slug
  end

  def canonical_title
    object.canonical_title
  end

  def cover_image
    object.cover_image_file_name ? object.cover_image.url(:thumb) : nil
  end

  def cover_image_top_offset
    object.cover_image_top_offset || 0
  end

  def poster_image
    object.poster_image.url(:large)
  end

  def genres
    object.genres.map {|x| x.name.parameterize }.sort
  end

  def started_airing
    object.started_airing_date
  end

  def finished_airing
    object.finished_airing_date
  end

  def screencaps
    object.gallery_images.limit(4).map {|g| g.image.url(:thumb) }
  end

  def languages
    object.castings.where(role: "Voice Actor").select("DISTINCT(language)").map {|x| x.language }
  end

  def featured_quotes
    Quote.includes(:user).find_with_reputation(:votes, :all, {:conditions => ["anime_id = ?", object.id], :order => "votes DESC", :limit => 4})
  end

  def trending_reviews
    object.reviews.includes(:user).order("wilson_score DESC").limit(4)
  end

  def featured_castings
    object.castings.where(featured: true).includes(:person, :character).sort_by {|x| x.order || 100 }
  end

  def community_ratings
    ratings = []
    0.upto(5).each do |i|
      previous_rating = (object.rating_frequencies["#{i}.0"] || 0).to_i
      next_rating     = (object.rating_frequencies["#{i+1}.0"] || 0).to_i
      current_rating  = (object.rating_frequencies["#{i}.5"] || 0).to_i

      ratings.push previous_rating
      if current_rating < previous_rating and current_rating < next_rating
        current_rating = (next_rating + previous_rating) / 2
      end
      ratings.push current_rating
    end
    ratings.pop; ratings.shift
    ratings
  end

  def is_favorite
    scope && scope.has_favorite?(object)
  end

  def library_status
    if scope
      watchlist = Watchlist.where(user_id: scope, anime_id: object)
      if watchlist.length > 0
        watchlist.first.status
      else
        nil
      end
    else
      nil
    end
  end

  def bayesian_rating
    object.bayesian_average
  end
end
