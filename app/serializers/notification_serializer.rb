class NotificationSerializer < ActiveModel::Serializer

  attributes :source_type, :source_user, :created_at, :notification_type, :seen

  def source_user 
    object.source.target.name
  end
end
