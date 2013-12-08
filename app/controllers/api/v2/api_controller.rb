class Api::V2::ApiController < ApplicationController
  # Render a JSON error with the given error message and status code.
  def error!(message, status)
    render json: {error: message}, status: status
  end
end
