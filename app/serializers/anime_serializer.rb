class AnimeSerializer < ActiveModel::Serializer
  embed :ids, include: true

  attributes :id, :canonical_title, :synopsis, :poster_image, :genres, :show_type, :age_rating, :age_rating_guide, :episode_count, :episode_length, :started_airing, :finished_airing, :screencaps

  has_many :featured_quotes, root: :quotes

  def id
    object.slug
  end

  def canonical_title
    object.canonical_title
  end

  def poster_image
    object.cover_image.url(:thumb)
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
    object.gallery_images.map {|g| g.image.url(:thumb) }
  end

  def featured_quotes
    Quote.includes(:user).find_with_reputation(:votes, :all, {:conditions => ["anime_id = ?", object.id], :order => "votes DESC", :limit => 4})
  end
end
