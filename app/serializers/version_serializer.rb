class VersionSerializer < ActiveModel::Serializer
  embed :ids, include: true

  attributes :id, :state, :object_type, :object_changes, :created_at
  has_one :user, embed_key: :name

  has_one :anime, serializer: FullAnimeSerializer,
    embed_key: :slug, root: :full_anime
  has_one :manga, serializer: FullMangaSerializer,
    embed_key: :slug, root: :full_manga

  def anime
    object.item
  end

  def include_anime?
    object.item.is_a?(Anime)
  end

  def manga
    object.item
  end

  def include_manga?
    object.item.is_a?(Manga)
  end

  def object_type
    object.item_type.downcase
  end

  def attributes
    hash = super
    hash['object'] = object.object
    hash
  end
end
