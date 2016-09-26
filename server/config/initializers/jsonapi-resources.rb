JSONAPI.configure do |config|
  config.json_key_format = :camelized_key
  config.default_paginator = :offset
  config.default_page_size = 10
  config.maximum_page_size = 20
end
