class ApplicationController < ActionController::Base
  protect_from_forgery

  def mixpanel
    @mixpanel ||= Mixpanel::Tracker.new '92b66301c752642b40ca39e718517d94', { :async => true, :env => request.env }
  end
end
