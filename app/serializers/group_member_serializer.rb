class GroupMemberSerializer < ActiveModel::Serializer
  embed :ids, include: true

  attributes :id, :admin, :pending
  has_one :group, embed_key: :slug
  has_one :user, embed_key: :name
end
