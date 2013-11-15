class CastingSerializer < ActiveModel::Serializer
  embed :ids, include: true

  attributes :id, :role, :language
  has_one :person
  has_one :character
end
