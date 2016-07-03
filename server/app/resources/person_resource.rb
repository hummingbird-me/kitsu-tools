class PersonResource < BaseResource
  attributes :image, :name, :mal_id

  has_many :castings
end
