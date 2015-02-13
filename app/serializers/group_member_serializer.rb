class GroupMemberSerializer < ActiveModel::Serializer
  embed :ids, include: true

  attributes :id, :rank, :pending, :group_id
  has_one :user, embed_key: :name

  def group_id
    object.group.slug
  end
end
