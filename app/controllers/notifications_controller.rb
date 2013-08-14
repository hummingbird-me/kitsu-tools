class NotificationsController < ApplicationController
  before_filter :authenticate_user!

  def show
    hide_cover_image
  end
end
