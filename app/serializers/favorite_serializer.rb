class FavoriteSerializer < ActiveModel::Serializer
  embed :ids, include: true

  attributes :id,
             :user_id,
             :fav_rank

  def item_id
    object.item.slug
  end

  def item_type
    object.item_type.downcase
  end

  has_one :item, polymorphic: true, embed_key: :slug
  has_one :user, embed_key: :name
end
