module Api::V2
  class ApiController < ActionController::Base
    force_ssl if: -> { Rails.env.production? }
  end
end
