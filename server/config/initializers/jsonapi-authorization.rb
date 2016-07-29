JSONAPI.configure do |config|
  config.operations_processor = :jsonapi_authorization
end

JSONAPI::Authorization.configure do |config|
  config.authorizer = JSONAPI::Authorization::PunditAuthorizer
end
