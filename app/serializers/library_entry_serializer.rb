class LibraryEntrySerializer < ActiveModel::Serializer
  embed :ids

  attributes :id, :status, :is_favorite, :rating, :episodes_watched, :private, :rewatching, :rewatch_count, :last_watched, :notes
  has_one :anime, embed_key: :slug, include: true

  def include_private?
    object.private?
  end

  def include_notes?
    object.notes and object.notes.strip.length > 0
  end

  def is_favorite
    # HACK TO PREVENT N+1
    if object.respond_to? :favorite_id
      object.favorite_id.present?
    else
      scope && scope.has_favorite?(object.anime)
    end
  end

  def last_watched
    object.last_watched || object.created_at
  end

end
