class NotificationSerializer < ActiveModel::Serializer

  attributes :id, :source_type, :source_avatar, :source_user, :created_at, :notification_type, :seen

  def user
    if object.source.is_a? Story
      object.source.target
    elsif object.source.is_a? Substory
      object.user
    end
  end

  def source_user
    user.name
  end

  def source_avatar
    user.avatar.url(:thumb_small)
  end
end
