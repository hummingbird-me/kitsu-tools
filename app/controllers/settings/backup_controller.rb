class Settings::BackupController < ApplicationController
  before_action :authenticate_user!

  def download
    filename = DateTime.now.strftime('hummingbird-%F-%T.json')
    response.headers["Content-Disposition"] = "attachment; filename=\"#{filename}\""

    current_user.update(last_backup: DateTime.now)
    render json: ListBackup.new(current_user)
  end

  def dropbox
    current_user.update(last_backup: DateTime.now)
    DropboxBackupWorker.perform_async(current_user.id)

    respond_to do |format|
      format.html { redirect_to :back }
      format.json { render json: current_user, serializer: CurrentUserSerializer }
    end
  end

  def dropbox_connect
    consumer = Dropbox::API::OAuth.consumer(:authorize)

    if params[:oauth_token] # Accept a Dropbox redirect
      request_token  = OAuth::RequestToken.from_hash(consumer, session[:dropbox_request_token])
      result = request_token.get_access_token(:oauth_verifier => params[:oauth_token])

      current_user.update(dropbox_token: result.token, dropbox_secret: result.secret)
      redirect_to '/settings'
    else # Redirect to Dropbox's OAuth2
      request_token = consumer.get_request_token
      session[:dropbox_request_token] = {
        oauth_token: request_token.token,
        oauth_token_secret: request_token.secret
      }
      redirect_to request_token.authorize_url(:oauth_callback => request.original_url)
    end
  end

  def dropbox_disconnect
    # Can we revoke ourselves and clear it out of their app list?
    current_user.update(dropbox_token: nil, dropbox_secret: nil)
    respond_to do |format|
      format.html { redirect_to :back }
      format.json { render json: current_user, serializer: CurrentUserSerializer }
    end
  end
end
