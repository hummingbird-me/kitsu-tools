class UsersController < ApplicationController
  def show
    if params[:id] == 'me'
      return error! 404, 'not found' unless signed_in?
      @user = current_user
    else
      @user = User.find(params[:id])
    end
    render json: @user
  end

  def create
    @user = deserialize(create: true)
    save_or_error! @user
  end

  def update
    # TODO: authenticate & authorize user
    @user = deserialize
    validate_id(@user) || return
    save_or_error! @user
  end

  def destroy
    # TODO: allow users to delete their accounts
  end
end
