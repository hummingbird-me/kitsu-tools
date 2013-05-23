class API_v1 < Grape::API
  version 'v1', using: :path, format: :json, vendor: 'hummingbird'
  
  resource :system do
    desc "Returns pong."
    get :ping do
      {ping: 'pong'}
    end
  end
end
