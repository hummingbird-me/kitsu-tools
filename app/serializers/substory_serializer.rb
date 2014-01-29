class SubstorySerializer < ActiveModel::Serializer
  attributes :id, :type, :created_at, :new_status, :episode_number

  def type
    object.substory_type
  end

  def new_status
    object.data["new_status"]
  end
  def include_new_status?
    object.substory_type == "watchlist_status_update"
  end

  def episode_number
    object.data["episode_number"]
  end
  def include_episode_number?
    object.substory_type == "watched_episode"
  end
end
