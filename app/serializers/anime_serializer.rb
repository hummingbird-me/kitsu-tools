class AnimeSerializer < ActiveModel::Serializer
  embed :ids

  attributes :id,
             :canonical_title,
             :english_title,
             :romaji_title,
             :synopsis,
             :poster_image,
             :show_type,
             :age_rating,
             :age_rating_guide,
             :episode_count,
             :episode_length,
             :started_airing,
             :started_airing_date_known,
             :finished_airing,
             :genres

  def id
    object.slug
  end

  def english_title
    object.alt_title
  end

  def romaji_title
    object.title
  end

  def poster_image
    if !object.sfw? && (scope.nil? || scope.try(:sfw_filter))
      "/assets/missing-anime-cover.jpg"
    else
      object.poster_image_thumb
    end
  end

  def episode_count
    (object.episode_count && object.episode_count > 0) ? object.episode_count : nil
  end

  def episode_length
    (object.episode_length && object.episode_length > 0) ? object.episode_length : nil
  end

  def started_airing
    object.started_airing_date
  end

  def finished_airing
    object.finished_airing_date
  end

  def genres
    object.genres.map(&:name).sort
  end
end
