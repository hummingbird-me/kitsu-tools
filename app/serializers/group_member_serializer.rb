class GroupMemberSerializer < ActiveModel::Serializer
  embed :ids, include: true

  attributes :id, :rank, :pending
  # don't include group, we don't query GroupMember's without knowing the group
  # first, and this saves the serialized data having duplicate group entries.
  has_one :group, embed_key: :slug, include: false
  has_one :user, embed_key: :name
end
