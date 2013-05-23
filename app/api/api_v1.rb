class API_v1 < Grape::API
  version 'v1', using: :path, format: :json, vendor: 'hummingbird'

  before do
    @start_time = Time.now
  end
  
  after do
    @end_time = Time.now
    $riemann << {
      service: "api req",
      metric: (@end_time - @start_time).to_f,
      state: "ok"
    }
  end
  
  resource :system do
    desc "Returns pong."
    get :ping do
      sleep 1
      {ping: 'pong'}
    end
  end
end
