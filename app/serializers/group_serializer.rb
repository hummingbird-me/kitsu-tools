class GroupSerializer < ActiveModel::Serializer
  embed :ids, include: true

  attributes :id, :name, :avatar_url, :cover_image_url, :bio,
    :about, :member_count

  has_one :current_member, root: :group_members
  has_many :members, root: :group_members

  def id
    object.slug
  end

  def avatar_url
    object.avatar.url(:thumb)
  end

  def cover_image_url
    object.cover_image.url(:thumb)
  end

  # Includes the 14 most recent GroupMembers
  def members
    object.members.accepted.order('created_at DESC').take(14)
  end

  def member_count
    object.confirmed_members_count
  end

  # will return a record for a pending member too
  def current_member
    scope && object.member(scope)
  end
end
