class LibraryEntrySerializer < ActiveModel::Serializer
  embed :ids

  attributes :id, :status, :is_favorite, :rating, :episodes_watched, :private, :rewatching, :rewatch_count, :last_watched
  has_one :anime, embed_key: :slug, include: true

  def include_private?
    object.private?
  end

  def is_favorite
    if object.respond_to? :favorite_id
      !object.favorite_id.nil?
    else
      scope && scope.has_favorite?(object.anime)
    end
  end

  def rewatch_count
    object.rewatched_times
  end

  def last_watched
    object.last_watched || object.created_at
  end
end
