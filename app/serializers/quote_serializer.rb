class QuoteSerializer < ActiveModel::Serializer
  attributes :id,
             :anime_id,
             :character_name,
             :content,
             :username,
             :favorite_count,
             :is_favorite

  def anime_id
    object.anime.slug
  end

  def username
    object.user.name
  end

  def favorite_count
    object.positive_votes
  end

  def is_favorite
    scope && Vote.for(scope, object).present?
  end
end
