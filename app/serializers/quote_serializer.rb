class QuoteSerializer < ActiveModel::Serializer
  attributes :id, :character_name, :content, :username, :favorite_count, :is_favorite

  def username
    object.user.name
  end

  def favorite_count
    object.positive_votes
  end

  def is_favorite
    scope && scope.voted_for?(object)
  end
end
