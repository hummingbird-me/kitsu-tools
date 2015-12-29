class CastingResource < BaseResource
  attributes :role, :voice_actor, :featured, :language

  has_one :media, polymorphic: true
  has_one :character
# has_one :person
end
