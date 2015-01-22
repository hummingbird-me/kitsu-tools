class GroupSerializer < ActiveModel::Serializer
  embed :ids, include: true

  attributes :id, :name, :avatar, :cover_image, :bio, :about, :member_count
  has_many :members, root: :group_members

  def id
    object.slug
  end

  def avatar
    object.avatar.url(:thumb)
  end

  def cover_image
    object.cover_image.url(:thumb)
  end

  # Includes the 14 most recent GroupMembers, and the current users
  # GroupMember record, if it exists.
  def members
    user = scope && object.member(scope)
    members = object.members.accepted.order('created_at DESC').take(14)
    (members + (user ? [user] : [])).uniq
  end

  def member_count
    object.members.accepted.count
  end
end
