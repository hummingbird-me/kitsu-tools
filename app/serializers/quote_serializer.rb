class QuoteSerializer < ActiveModel::Serializer
  attributes :id, :character_name, :content, :username, :favorite_count, :is_favorite

  def username
    object.user.name
  end

  def favorite_count
    object.votes rescue object.reputation_for(:votes)
  end

  def is_favorite
    scope && object.has_evaluation?(:votes, scope)
  end
end
