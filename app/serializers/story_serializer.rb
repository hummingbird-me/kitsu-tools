class StorySerializer < ActiveModel::Serializer
  embed :ids, include: true
  attributes :id, :type, :created_at

  has_one :user, embed_key: :name
  has_one :poster, embed_key: :name, root: :users

  def type
    object.story_type
  end

  def poster
    object.target
  end
  def include_poster?
    object.story_type == "comment"
  end
end
