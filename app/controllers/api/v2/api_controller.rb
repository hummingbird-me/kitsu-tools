class Api::V2::ApiController < ApplicationController
  before_filter :authenticate_user_from_token_param!

  # Render a JSON error with the given error message and status code.
  def error!(message, status)
    render json: {error: message}, status: status
  end

  def authenticate_user_from_token_param!
    if params[:auth_token]
      user = User.where(authentication_token: params[:auth_token]).first
      if user
        sign_in user, store: false
      else
        return error!("invalid/expired auth_token", :unauthorized)
      end
    end
  end
end
