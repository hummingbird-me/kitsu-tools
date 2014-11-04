class UserInfoSerializer < ActiveModel::Serializer
  attributes :id, :life_spent_on_anime, :anime_watched, :top_genres

  def anime_watched
    object.library_entries.where(status: "Completed").count
  end

  def top_genres
    object.top_genres
  end
end
