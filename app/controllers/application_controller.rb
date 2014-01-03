class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :preload_user

  # Send an object along with the initial HTML response so that Ember will not need
  # to make additional requests to fetch data.
  def preload!(data, options={})
    @preload ||= []
    data = [data] unless data.is_a? Array
    options[:scope] = current_user
    options[:root] = data.first.class.to_s.underscore.pluralize
    @preload.push(ActiveModel::ArraySerializer.new(data, options))
  end

  def preload_user
    if user_signed_in?
      preload! current_user
      Rack::MiniProfiler.authorize_request if current_user.id == 1
    end
  end

  def render_ember
    render "layouts/redesign", layout: false
  end

  # Render a JSON error with the given error message and status code.
  def error!(message, status)
    render json: {error: message}, status: status
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
