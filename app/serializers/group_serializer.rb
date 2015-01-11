class GroupSerializer < ActiveModel::Serializer
  embed :ids

  attributes :id, :name, :avatar, :cover_image, :bio, :about

  has_many :members, root: :group_members

  def id
    object.slug
  end
end
