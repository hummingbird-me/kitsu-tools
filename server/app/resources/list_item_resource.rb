class ListItemResource < JSONAPI::Resource
  has_one :content, as: :listable
end
