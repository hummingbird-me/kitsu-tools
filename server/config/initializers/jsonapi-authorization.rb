require 'jsonapi/authorization/transactional_authorizing_processor'
JSONAPI.configure do |config|
  config.operations_processor = :transactional_authorization
end
