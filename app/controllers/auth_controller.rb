class AuthController < ApplicationController
  def sign_out_action
    sign_out :user
    respond_to do |format|
      format.json { render json: true }
      format.html { redirect_to(root_url) }
    end
  end

  def sign_in_action
    unless %i(email password).none? { |x| params[x].blank? }
      return error! 'Missing parameters', 400
    end

    key = params[:email].include?('@') ? :email : :name
    user = User.where("lower(#{key}) = ?", params[:email].downcase).first

    if user && user.valid_password?(params[:password])
      sign_in :user, user
      render json: true
    else
      error! 'Username or password incorrect', 401
    end
  end

  def sign_up_action
    unless %i(username email password).none? { |x| params[x].blank? }
      return error! 'Missing parameters', 400
    end
    return error! 'User with that email already exists', 409 if User.exists?(
      ['lower(email) = ?', params[:email].downcase])
    return error! 'User with that name already exists', 409 if User.exists?(
      ['lower(name) = ?', params[:username].downcase])

    user = User.new(
      name: params[:username],
      email: params[:email],
      password: params[:password]
    )
    user.save!

    sign_in user

    render json: user
  end
end
