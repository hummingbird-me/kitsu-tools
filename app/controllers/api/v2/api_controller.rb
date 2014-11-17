module Api::V2
  class ApiController < ActionController::Base
    force_ssl if Rails.env.production?

    def error!(status, info)
      info = { title: info } if info.is_a?(String)

      render json: {
        errors: [
          info.merge({status: Rack::Utils::HTTP_STATUS_CODES[status]})
        ]
      }, status: status
    end

    def require_client_id
      unless request.headers['X-Client-Id'] && App.exists?(key: request.headers['X-Client-Id'])
        error! 403, {
          title: "Missing or invalid API key; please pass the X-Client-Id header",
          details: "Access to APIv2 is restricted to registered applications. Please create an application and pass the unique API key generated as the X-Client-Id header.",
          href: "https://hummingbird.me/apps/mine"
        }
      end
    end
    before_filter :require_client_id
  end
end
