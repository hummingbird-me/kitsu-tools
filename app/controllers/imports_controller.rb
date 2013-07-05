class ImportsController < ApplicationController
  before_filter :authenticate_user!
  
  def myanimelist
    respond_to do |format|
      format.html do
        if params["mal_username"] && params["mal_username"].strip.length > 0
          @user = current_user
          @user.mal_username = params["mal_username"].strip
          @user.save
          @staged_import = StagedImport.find_or_create_by_user_id(@user.id)
          @staged_import.data = {version: 1, complete: false}
          @staged_import.save
          MALImportWorker.perform_async(@user.mal_username, @staged_import.id)
          redirect_to :back
        else
          flash[:alert] = "MyAnimeList username was blank."
          redirect_to :back
        end
      end
      format.json do
        # This bit is used by the onboarding import process.
        if params[:mal_username] and params[:mal_username].strip.length > 0
          current_user.mal_username = params[:mal_username].strip
          current_user.save
          staged_import = StagedImport.find_or_create_by_user_id(current_user.id)
          staged_import.data = {version: 1, complete: false, apply: true}
          staged_import.save
          MALImportWorker.perform_async(current_user.mal_username, staged_import.id)
          render :json => true
        else
          render :json => false
        end
      end
    end
  end
  
  def status
    respond_to do |format|
      format.json { render :json => current_user.staged_import.nil? }
    end
  end
  
  def review
    @staged_import = current_user.staged_import
    if @staged_import.nil? or !@staged_import.data[:complete]
      redirect_to "/users/edit#import"
    else
      @watchlist = Kaminari.paginate_array(MalImport.get_watchlist_from_staged_import(@staged_import, per: 100, page: params[:page])).page(params[:page]).per(100)
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
    redirect_to "/users/edit#import"
  end
end
