class ApplicationController < ActionController::Base
  def forem_user; current_user; end
  helper_method :forem_user

  protect_from_forgery

  def mixpanel
    @mixpanel ||= Mixpanel::Tracker.new '92b66301c752642b40ca39e718517d94', { :async => true, :env => request.env }
  end

  def after_sign_in_path_for(resource)
    "/dashboard"
  end
  
  def after_sign_out_path_for(resource)
    request.referrer
  end
end
