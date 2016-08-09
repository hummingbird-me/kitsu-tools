class ListResource < JSONAPI::Resource
  has_many :items
end
