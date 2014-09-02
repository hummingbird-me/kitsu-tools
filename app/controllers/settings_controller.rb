class SettingsController < ApplicationController
  before_action :authenticate_user!

  def index
    render layout: 'redesign'
  end
end
