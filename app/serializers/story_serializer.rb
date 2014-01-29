class StorySerializer < ActiveModel::Serializer
  embed :ids, include: true

  attributes :id, :type, :created_at, :comment

  has_one :user, embed_key: :name
  has_one :poster, embed_key: :name, root: :users
  has_one :media, polymorphic: true, embed_key: :slug

  def type
    object.story_type
  end

  def poster
    object.target
  end
  def include_poster?
    object.story_type == "comment"
  end

  def comment
    object.substories.first.data["formatted_comment"]
  end
  def include_comment?
    object.story_type == "comment"
  end

  def media
    object.target
  end
  def include_media?
    object.story_type == "media_story"
  end
end
