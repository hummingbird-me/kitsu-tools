class Users::RegistrationsController < Devise::RegistrationsController
  def edit
    hide_cover_image
    render :edit
  end
end
