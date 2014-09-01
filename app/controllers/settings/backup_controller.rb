class Settings::BackupController < ApplicationController
  before_action :authenticate_user!

  def download
    filename = DateTime.now.strftime('hummingbird-%F-%T.json')
    response.headers["Content-Disposition"] = "attachment; filename=\"#{filename}\""

    render json: ListBackup.new(current_user)
  end
  def dropbox
    consumer = Dropbox::API::OAuth.consumer(:authorize)
    if params[:oauth_token]
      request_token  = OAuth::RequestToken.from_hash(consumer, session[:dropbox_request_token])
      result = request_token.get_access_token(:oauth_verifier => params[:oauth_token])

      current_user.update(dropbox_token: result.token, dropbox_secret: result.secret)
      redirect_to '/users/edit'
    else
      request_token = consumer.get_request_token
      session[:dropbox_request_token] = {
        oauth_token: request_token.token,
        oauth_token_secret: request_token.secret
      }
      redirect_to request_token.authorize_url(:oauth_callback => request.original_url)
    end
  end
  def dropbox_disconnect
    # Can we revoke ourselves?
    current_user.update(dropbox_token: nil, dropbox_secret: nil)
    redirect_to :back
  end
end
