class QuoteSerializer < ActiveModel::Serializer
  attributes :id, :character_name, :content, :username, :favorite_count

  def username
    object.user.name
  end

  def favorite_count
    object.votes rescue object.reputation_for(:votes)
  end
end
