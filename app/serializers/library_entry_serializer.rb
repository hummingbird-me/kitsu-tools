class LibraryEntrySerializer < ActiveModel::Serializer
  embed :ids

  attributes :id, :status, :rating, :episodes_watched, :private, :rewatching, :rewatch_count, :last_watched, :notes
  has_one :anime, embed_key: :slug, include: true

  def include_private?
    object.private?
  end

  def include_notes?
    object.notes and object.notes.strip.length > 0
  end

  def last_watched
    object.last_watched || object.created_at
  end
end
