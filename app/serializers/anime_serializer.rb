class AnimeSerializer < ActiveModel::Serializer
  embed :ids

  attributes :id, :canonical_title, :english_title, :romaji_title, :synopsis, :poster_image, :show_type, :age_rating, :age_rating_guide, :episode_count, :episode_length, :started_airing, :started_airing_date_known, :finished_airing, :genres

  def id
    object.slug
  end

  def canonical_title
    object.canonical_title
  end

  def english_title
    object.alt_title
  end

  def romaji_title
    object.title
  end

  def poster_image
    object.poster_image_thumb
  end

  def episode_count
    (object.episode_count and object.episode_count > 0) ? object.episode_count : nil
  end

  def episode_length
    (object.episode_length and object.episode_length > 0) ? object.episode_length : nil
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

  def genres
    object.genres.map {|x| x.name }.sort
  end
end
