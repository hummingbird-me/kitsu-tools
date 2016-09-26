JSONAPI.configure do |config|
  config.default_processor_klass = JSONAPI::Authorization::TransactionalProcessor
  config.exception_class_whitelist = [Pundit::NotAuthorizedError]
end

JSONAPI::Authorization.configure do |config|
  config.authorizer = JSONAPI::Authorization::PunditAuthorizer
end
