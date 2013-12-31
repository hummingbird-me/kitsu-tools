class LibraryEntrySerializer < ActiveModel::Serializer
  embed :ids

  attributes :id, :status, :is_favorite, :rating
  has_one :anime, embed_key: :slug

  def is_favorite
    scope && scope.has_favorite?(object.anime)
  end
end
