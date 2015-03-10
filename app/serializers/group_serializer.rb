class GroupSerializer < ActiveModel::Serializer
  embed :ids, include: true

  attributes :id, :name, :avatar_url, :cover_image_url, :bio,
    :about, :member_count, :about_formatted

  has_one :current_member, root: :group_members

  def id
    object.slug
  end

  def avatar_url
    object.avatar.url(:thumb)
  end

  def cover_image_url
    object.cover_image.url(:thumb)
  end

  def member_count
    object.confirmed_members_count
  end

  # will return a record for a pending member too
  def current_member
    scope && object.member(scope)
  end
end
