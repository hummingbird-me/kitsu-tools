class SettingsController < ApplicationController
  before_action :authenticate_user!

  def index
    render layout: 'redesign'
  end

  def resend_confirmation
    current_user.resend_confirmation_instructions
    render json: true
  end
end
