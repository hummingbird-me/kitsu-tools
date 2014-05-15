class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :check_user_authentication
  before_filter :configure_permitted_parameters, if: :devise_controller?

  # Send an object along with the initial HTML response so that Ember will not need
  # to make additional requests to fetch data.
  def preload!(data, options={})
    @preload ||= []
    data = [data] unless data.is_a? Array
    options[:scope] = current_user
    options[:root] ||= data.first.class.to_s.underscore.pluralize
    options[:each_serializer] = options[:serializer] if options[:serializer]
    @preload << ActiveModel::ArraySerializer.new(data, options)
  end

  def check_user_authentication
    if user_signed_in?
      sign_out :user unless cookies[:auth_token]
      preload! current_user
      $redis.hset("user_last_seen", current_user.id.to_s, Time.now.to_i)
    elsif cookies[:auth_token]
      sign_in User.find_by_authentication_token(cookies[:auth_token])
    end
  end

  def render_ember
    render "layouts/redesign", layout: false
  end

  # Render a JSON error with the given error message and status code.
  def error!(message, status)
    render json: {error: message}, status: status
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

  protected
  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) << :name
  end
end
