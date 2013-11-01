class AnimeSerializer < ActiveModel::Serializer
  attributes :id, :canonical_title, :synopsis, :poster_image, :genres, :show_type, :age_rating, :age_rating_guide, :episode_count, :episode_length, :started_airing, :finished_airing

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
end
