class LibraryEntrySerializer < ActiveModel::Serializer
  embed :ids

  attributes :id, :status, :is_favorite, :rating, :canonical_title
  has_one :anime, embed_key: :slug

  def canonical_title
    object.anime.canonical_title
  end

  def is_favorite
    if object.respond_to? :favorite_id
      !object.favorite_id.nil?
    else
      scope && scope.has_favorite?(object.anime)
    end
  end
end
