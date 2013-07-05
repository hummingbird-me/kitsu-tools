class Users::ConfirmationsController < Devise::ConfirmationsController
  private
  def after_confirmation_path_for(resource_name, resource)
    "/?signup_tour=true"
  end
end
