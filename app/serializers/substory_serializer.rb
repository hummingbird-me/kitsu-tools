class SubstorySerializer < ActiveModel::Serializer
  embed :ids, include: true

  attributes :id, :type, :created_at, :new_status, :episode_number,
    :reply, :story_id

  has_one :user, embed_key: :name

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

  def reply
    object.data["reply"]
  end
  def include_reply?
    object.substory_type == "reply"
  end

  def user
    case object.substory_type
    when "followed"
      object.target
    when "reply"
      object.user
    end
  end
  def include_user?
    %w[followed reply].include? object.substory_type
  end
end
