class FavoriteSerializer < ActiveModel::Serializer
  embed :ids, include: true

  attributes :id,
             :user_id,
             :item_id,
             :item_type,
             :fav_rank

  
  def user_id
    object.user.name
  end

  has_one :item, polymorphic: true
end
