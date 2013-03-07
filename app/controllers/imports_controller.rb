class ImportsController < ApplicationController
  before_filter :authenticate_user!
  
  def myanimelist
    @user = current_user
    @user.mal_username = params["mal_username"]
    @user.save
    @staged_import = StagedImport.find_or_create_by_user_id(@user.id)
    @staged_import.data = {version: 1, complete: false}
    @staged_import.save
    MALImportWorker.perform_async(params["mal_username"], @staged_import.id)
    redirect_to :back
  end
  
  def review
    @staged_import = current_user.staged_import
    if @staged_import.nil? or !@staged_import.data[:complete]
      redirect_to "/users/edit#import"
    else
      @watchlist = MalImport.get_watchlist_from_staged_import(@staged_import)
      @reviews = MalImport.get_reviews_from_staged_import(@staged_import)
    end
  end

  def apply
    @staged_import = current_user.staged_import
    
    unless @staged_import.nil? or !@staged_import.data[:complete]
      @staged_import.data[:applying] = true
      @staged_import.save
      MALImportApplyWorker.perform_async(current_user.id)
    end
    
    redirect_to "/users/edit#import"
  end

  def cancel
    import = current_user.staged_import
    import.delete
    redirect_to :back
  end
end
