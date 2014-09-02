class AuthController < ApplicationController
  def sign_out_action
    sign_out :user
    render json: true
  end
end
