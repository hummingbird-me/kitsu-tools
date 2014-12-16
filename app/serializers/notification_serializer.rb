require_dependency 'story_query'

class NotificationSerializer < ActiveModel::Serializer
  embed :ids, include: true

  attributes :id, :created_at, :notification_type, :seen

  has_one :source, polymorphic: true

  def source
    if object.source_type == "Story"
      StoryQuery.find_by_id(object.source_id, scope)
    else
      object.source
    end
  end
end
