class CharacterResource < BaseResource
  attributes :slug, :name, :image, :mal_id, :description

  has_one :primary_media, polymorphic: true
  has_many :castings
end
