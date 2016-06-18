class MappingResource < BaseResource
  attributes :external_site, :external_id
  has_one :media
end
