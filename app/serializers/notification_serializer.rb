class NotificationSerializer < ActiveModel::Serializer

  attributes :id, :source_type, :source_avatar, :source_user, :created_at, :notification_type, :seen

  def source_user 
    object.source.target.name
  end

  def source_avatar
    object.source.target.avatar.url
  end
end
