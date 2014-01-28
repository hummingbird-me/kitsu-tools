class StorySerializer < ActiveModel::Serializer
  attributes :id, :type

  def type
    object.story_type
  end
end
