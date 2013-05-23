class API_v1 < Grape::API
  version 'v1', using: :path, format: :json, vendor: 'hummingbird'

  before do
    @start_time = Time.now
  end
  
  after do
    @end_time = Time.now
    lat = (@end_time - @start_time).to_f
    $riemann << {
      service: "api req",
      metric: lat,
      state: "ok"
    }
  end
  
  resource :system do
    desc "Returns pong."
    get :ping do
      sleep 5*rand
      {ping: 'pong'}
    end
  end
end
