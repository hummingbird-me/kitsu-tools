class NotificationSerializer < ActiveModel::Serializer

  attributes :id, :source_type, :source_avatar, :source_user, :created_at, :notification_type, :seen

  def source_user
    object.source_user.name
  end

  def source_avatar
    object.source_user.avatar.url(:thumb_small)
  end
end
