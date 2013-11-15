class UserSerializer < ActiveModel::Serializer
  attributes :id, :username, :cover_image_url, :avatar_template, :online, :about, 
    :is_followed

  def id
    object.name
  end

  def username
    object.name
  end

  def cover_image_url
    object.cover_image.url(:thumb)
  end

  def avatar_template
    object.avatar_template
  end

  def online
    object.online?
  end

  # Is the current_user following this user?
  def is_followed
    if scope
      (scope.id != object.id) and (object.followers.include? scope)
    else
      false
    end
  end
end

