require 'deserializer/helper'

class ApplicationController < ActionController::API
  include Deserializer::Helper
  include Pundit

  force_ssl if Rails.env.production?

  ##
  # Renders an error message or a model's error messages
  #
  # = Examples
  #
  # `error! 500, 'Server is a dog'`
  # `error! user`
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

  ##
  # Attempts to save a model instance.  If it fails, renders the error info. If
  # it succeeds, renders the JSON representation of it.
  def save_or_error!(model)
    if model.save
      render json: model
    else
      error! model
    end
  end

  ##
  # Check that params[:id] matches a given instance's id field
  #
  # = Examples
  #
  # `check_id! user`
  # `check_id! comment, :comment_id`
  def validate_id(model, param = :id)
    if model.id == params[param]
      true
    else
      error! 400, 'ID mismatch'
    end
  end
end
