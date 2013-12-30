class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :preload_user

  # Send an object along with the initial HTML response so that Ember will not need
  # to make additional requests to fetch data.
  def preload!(key, data)
    @preload ||= []
    data = [data] unless data.is_a? Array
    @preload.push({object_type: key, object: ActiveModel::ArraySerializer.new(data, scope: current_user, root: key.pluralize)})
  end

  def preload_user
    if user_signed_in?
      preload! "user", current_user
      Rack::MiniProfiler.authorize_request if current_user.id == 1
    end
  end

  def render_ember
    render "layouts/redesign", layout: false
  end

  ### PRE-EMBER CODE BELOW -- NEEDS REWRITING.

  before_filter :user_last_seen

  def user_last_seen
    if user_signed_in?
      $redis.hset("user_last_seen", current_user.id.to_s, Time.now.to_i)
    end
  end

  def hide_cover_image
    @hide_cover_image = true
  end

  def mixpanel
    @mixpanel ||= Mixpanel::Tracker.new '92b66301c752642b40ca39e718517d94', { :async => true, :env => request.env }
  end

  def after_sign_in_path_for(resource)
    stored_location_for(resource) || user_path(resource)
  end

  def after_sign_out_path_for(resource)
    request.referrer
  end

  def not_found!
    raise ActionController::RoutingError.new('Not Found')
  end
end
