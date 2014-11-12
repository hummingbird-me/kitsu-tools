class VersionSerializer < ActiveModel::Serializer
  embed :ids, include: true

  attributes :id, :state, :object_changes, :created_at
  has_one :item, polymorphic: true, embed_key: :slug
  has_one :user, embed_key: :name

  def attributes
    hash = super
    hash['object'] = object.object
    hash
  end
end
