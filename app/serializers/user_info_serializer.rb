class UserInfoSerializer < ActiveModel::Serializer
  attributes :id, :life_spent_on_anime, :anime_total, :anime_watched, :top_genres

  def anime_total
  	Anime.all.count
  end

  def anime_watched
  	object.watchlists.all.count
  end

  def top_genres
  	object.top_genres
  end
end
