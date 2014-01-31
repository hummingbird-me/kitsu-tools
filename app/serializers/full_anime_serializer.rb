class FullAnimeSerializer < AnimeSerializer
  embed :ids, include: true

  attributes :alternate_title, :cover_image, :cover_image_top_offset, :screencaps,
    :languages, :community_ratings, :youtube_video_id, :bayesian_rating, :genres

  has_many :featured_quotes, root: :quotes
  has_many :trending_reviews, root: :reviews
  has_many :featured_castings, root: :castings
  has_many :producers, embed_key: :slug
  has_many :franchises, include: false
  has_one :library_entry

  def alternate_title
    object.alternate_title
  end

  def cover_image
    object.cover_image_file_name ? object.cover_image.url(:thumb) : nil
  end

  def cover_image_top_offset
    object.cover_image_top_offset || 0
  end

  def screencaps
    object.gallery_images.limit(4).map {|g| g.image.url(:thumb) }
  end

  def languages
    object.castings.where(role: "Voice Actor").select("DISTINCT(language)").map {|x| x.language }
  end

  def featured_quotes
    object.quotes.includes(:user).order('positive_votes DESC').limit(4)
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
end
