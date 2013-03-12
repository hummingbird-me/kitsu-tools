class ApplicationController < ActionController::Base
  protect_from_forgery

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
