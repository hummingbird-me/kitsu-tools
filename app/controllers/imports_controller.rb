class ImportsController < ApplicationController
  def myanimelist
    authenticate_user!
    @user = current_user
    @user.mal_username = params["mal_username"]
    @user.save
    @staged_import = StagedImport.find_or_create_by_user_id(@user.id)
    @staged_import.data = {}
    @staged_import.save
    redirect_to :back
  end
end
