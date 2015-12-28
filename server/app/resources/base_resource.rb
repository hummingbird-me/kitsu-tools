class BaseResource < JSONAPI::Resource
  abstract
  include AuthenticatedResource
  include SearchableResource
end
