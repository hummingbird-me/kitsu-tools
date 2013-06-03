class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :fuck_off_lisa
  def fuck_off_lisa
    sleep 24 if user_signed_in? and current_user.id == 951
  end

  def forem_user; current_user; end
  helper_method :forem_user

  def hide_cover_image
    @hide_cover_image = true
  end

  def mixpanel
    @mixpanel ||= Mixpanel::Tracker.new '92b66301c752642b40ca39e718517d94', { :async => true, :env => request.env }
  end

  def after_sign_in_path_for(resource)
    stored_location_for(resource) || "/dashboard"
  end
  
  def after_sign_out_path_for(resource)
    request.referrer
  end
end
