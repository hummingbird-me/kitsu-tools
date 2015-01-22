class UserInfoSerializer < ActiveModel::Serializer
  embed :ids, include: true
  attributes :id, :life_spent_on_anime, :anime_watched, :top_genres

  has_many :favorites, polymorphic: true

  def id
    object.name
  end

  def anime_watched
    object.library_entries.where(status: "Completed").count
  end

  def top_genres
    object.top_genres
  end
end
