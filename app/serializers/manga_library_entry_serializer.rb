class MangaLibraryEntrySerializer < ActiveModel::Serializer
  embed :ids

  attributes :id,
             :status,
             :is_favorite,
             :rating,
             :chapters_readed,
             :volumes_readed,
             :private,
             :rereading,
             :rereading_count,
             :last_readed
  has_one :manga, embed_key: :slug, include: true
           
  def include_private?
    object.private?
  end


  def is_favorite
    scope and scope.respond_to?(:has_favorite2?) and scope.has_favorite2? object.manga
  end

  def last_readed
    object.last_readed || object.created_at
  end

end
