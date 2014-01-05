class ReviewSerializer < ActiveModel::Serializer
  embed :ids

  attributes :id, :summary, :rating, :positive_votes, :total_votes, :anime_title
  has_one :user, embed_key: :name
  has_one :anime, embed_key: :slug

  def anime_title
    object.anime.canonical_title(scope)
  end

  def summary
    object.summary || HTML::FullSanitizer.new.sanitize(object.content).truncate(130, separator: ' ', omission: '...')
  end

  def rating
    object.rating / 2.0
  end

  def attributes
    hash = super
    hash["user_id"] = object.user.name
    hash
  end
end
