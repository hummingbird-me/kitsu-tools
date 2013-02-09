class RegistrationsController < Devise::RegistrationsController
  def update
    @user = User.find(current_user.id)
    prev_unconfirmed_email = @user.unconfirmed_email if @user.respond_to?(:unconfirmed_email)
    
    if needs_password?(@user, params)
      success = @user.update_with_password(params[:user])
    else
      params[:user].delete(:current_password)
      success = @user.update_without_password(params[:user])
    end

    if success
      if is_navigational_format?
        flash_key = update_needs_confirmation?(resource, prev_unconfirmed_email) ?
          :update_needs_confirmation : :updated
        set_flash_message :notice, flash_key
      end
      sign_in resource_name, resource, :bypass => true
      respond_with resource, :location => after_update_path_for(resource)
    else
      clean_up_passwords resource
      respond_with resource
    end
  end
  
  # Never require the password.
  def needs_password?(user, params)
    false
  end
end
