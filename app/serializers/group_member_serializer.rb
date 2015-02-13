class GroupMemberSerializer < ActiveModel::Serializer
  embed :ids, include: true

  attributes :id, :rank, :pending, :group_id
  has_one :group, embed_key: :slug
  has_one :user, embed_key: :name

  def group_id
    object.group.slug
  end
end
