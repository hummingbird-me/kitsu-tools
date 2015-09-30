require 'deserializer/helper'

class ApplicationController < ActionController::API
  include Deserializer::Helper

  force_ssl if Rails.env.production?

  def error!(status, message = 'Something went wrong')
    if status.respond_to?(:errors) # error!(model)
      # TODO: include 'source' field for JSON-API
      render json: {
        errors: status.errors.map { |e| {title: e} }
      }, status: 400
    else # error!(status, message)
      render json: {
        errors: [{ title: title }],
      }, status: errors
    end
  end
end
