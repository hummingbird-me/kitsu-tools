class StorySerializer < ActiveModel::Serializer
  embed :ids, include: true

  attributes :id, :type, :created_at, :comment, :substory_count

  has_one :user, embed_key: :name
  has_one :media, polymorphic: true, embed_key: :slug
  has_one :poster, embed_key: :name, root: :users
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
    first_substory = object.substories.select {|x| x.substory_type == "comment" }.try(:first)
    return unless first_substory
    first_substory.data["formatted_comment"]
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

  def substory_count
    object.substories.count
  end

  def substories
    object.substories.reject {|x| x.substory_type == "comment" }
                     .sort_by {|x| x.created_at }.reverse.take(2)
  end
end
