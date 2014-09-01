class Settings::BackupController < ApplicationController
  before_action :authenticate_user!

  def download
    filename = DateTime.now.strftime('hummingbird-%F-%T.json')
    response.headers["Content-Disposition"] = "attachment; filename=\"#{filename}\""

    render json: ListBackup.new(current_user)
  end
  def dropbox
    render json: {dropbox: 'route'}
  end
  def dropbox_callback
  end
  def dropbox_disconnect
    current_user.update_attributes(dropbox_token: nil)
    redirect_to :back
  end
end
