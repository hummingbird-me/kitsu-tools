class API < Grape::API
  prefix 'api'
  format :json
  mount API_v1
end

module Api
end
