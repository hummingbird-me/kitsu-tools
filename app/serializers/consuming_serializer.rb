class ConsumingSerializer < ActiveModel::Serializer
  embed :ids

  attributes :id,
             :status,
             :is_favorite,
             :rating,
             :parts_consumed,
             :blocks_consumed,
             :private,
             :reconsuming,
             :reconsume_count,
             :last_consumed,
             :item_type,
             :item_slug

  def include_private?
    object.private?
  end

  def item_slug
    object.item.slug
  end

  def is_favorite
    scope and scope.respond_to?(:has_favorite2?) and scope.has_favorite2? object.item
  end

  def last_consumed
    object.last_consumed || object.created_at
  end

end
