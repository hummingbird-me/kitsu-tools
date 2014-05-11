class StorySerializer < ActiveModel::Serializer
  embed :ids, include: true

  attributes :id, :type, :created_at, :comment

  has_one :user, embed_key: :name
  has_one :media, polymorphic: true, embed_key: :slug
  has_one :poster, embed_key: :name, root: :users
  has_many :followed_users, embed_key: :name, root: :users
  has_many :substories

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
    first_substory = object.substories.first and first_substory.data['formatted_comment']
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

  def include_substories?
    object.story_type == "media_story"
  end

  def followed_users
    object.substories.map {|x| x.target }
  end
  def include_followed_users?
    object.story_type == "followed"
  end
end
