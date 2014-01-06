class AnimeSerializer < ActiveModel::Serializer
  embed :ids, include: true

  attributes :id, :canonical_title, :synopsis, :poster_image, :genres, :show_type,
    :age_rating, :age_rating_guide, :episode_count, :episode_length,
    :started_airing, :started_airing_date_known, :finished_airing

  has_one :library_entry

  def id
    object.slug
  end

  def canonical_title
    object.canonical_title
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

  def bayesian_rating
    object.bayesian_average
  end

  def library_entry
    scope && LibraryEntry.where(user_id: scope.id, anime_id: object.id).first
  end
end
