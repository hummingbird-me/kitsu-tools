module ErrorHelpers
  extend ActiveSupport::Concern

  ##
  # Renders an error message or a model's error messages
  #
  # = Examples
  #
  # `error! 500, 'Server is a dog'`
  # `error! user`
  def error!(status, message = 'Something went wrong')
    if status.respond_to?(:errors) # error!(model)
      errors = status.errors.map do |field, issues|
        [issues].flatten.map do |issue|
          issue = { title: issue }
          # TODO: switch to JSON Pointer instead of Query Parameter
          issue[:source] = { parameter: field } unless field == :base
          issue
        end
      end

      render json: {
        errors: errors.flatten
      }, status: 400
    else # error!(status, message)
      render json: {
        errors: [{ title: message }]
      }, status: status
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
    if model.id.to_i == params[param].to_i
      true
    else
      error! 400, 'ID mismatch'
      false
    end
  end
end
