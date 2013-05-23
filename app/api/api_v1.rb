class API_v1 < Grape::API
  version 'v1', using: :path, format: :json, vendor: 'hummingbird'
  
  resource :system do
    desc "Returns pong."
    get :ping do
      $riemann << {service: 'api request', metric: 1}
      {ping: 'pong'}
    end
  end
end
