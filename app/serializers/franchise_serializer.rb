class FranchiseSerializer < ActiveModel::Serializer
  embed :ids, include: true

  attributes :id

  has_many :anime, embed_key: :slug
end
