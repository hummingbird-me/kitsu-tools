class UsersController < ApplicationController
  include FriendlyShow

  def show
    if params[:id] == 'me' && signed_in?
      redirect_to current_user
    else
      super
    end
  end
end
