class BaseResource < JSONAPI::Resource
  abstract
  include AuthenticatedResource
end
