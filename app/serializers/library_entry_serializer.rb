class LibraryEntrySerializer < ActiveModel::Serializer
  embed :ids

  attributes :id,
             :status,
             :is_favorite,
             :rating,
             :episodes_watched,
             :private,
             :rewatching,
             :rewatch_count,
             :last_watched,
             :notes

  has_one :anime, embed_key: :slug, include: true

  def include_private?
    object.private?
  end

  def include_notes?
    object.notes and object.notes.strip.length > 0
  end

  def is_favorite
    scope and scope.respond_to?(:has_favorite2?) and scope.has_favorite2? object.anime
  end

  def last_watched
    object.last_watched || object.created_at
  end

end
