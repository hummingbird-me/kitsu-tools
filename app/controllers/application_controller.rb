class ApplicationController < ActionController::Base
  force_ssl if Rails.env.production?
  protect_from_forgery

  before_filter :check_user_authentication, :preload_current_user,
                :preload_blotter

  before_filter :configure_permitted_parameters, if: :devise_controller?

  # Send an object along with the initial HTML response that will be loaded into
  # Ember Data's cache.
  def preload_to_ember!(data, options={})
    @preload ||= []
    data = ed_serialize(data, options)
    @preload << data unless data.nil?
  end

  def ed_serialize(data, options={})
    data = data.to_a if data.respond_to? :to_ary
    data = [data] unless data.is_a? Array
    return if data.empty?
    options[:scope] = current_user
    options[:root] ||= data.first.class.to_s.underscore.pluralize
    options[:each_serializer] = options[:serializer] if options[:serializer]
    ActiveModel::ArraySerializer.new(data, options)
  end

  # Preload for the generic non-ED preloader.
  def generic_preload!(key, value)
    @generic_preload ||= {}
    @generic_preload[key] = value
  end

  def check_user_authentication
    if user_signed_in?
      # Sign the user out if they have an incorrect auth token.
      unless cookies[:auth_token] && current_user.authentication_token == cookies[:auth_token]
        sign_out :user
      end
    elsif cookies[:auth_token]
      user = User.find_by(authentication_token: cookies[:auth_token])
      if user.current_sign_in_ip != request.remote_ip
        user.last_sign_in_ip = user.current_sign_in_ip
        user.current_sign_in_ip = request.remote_ip
        user.save!
      end
      sign_in(user) if user
    end
  end

  def preload_current_user
    return unless user_signed_in?
    preload_to_ember! current_user, serializer: CurrentUserSerializer,
                                    root: :current_users
  end

  def preload_blotter
    if user_signed_in?
      generic_preload! "blotter", Blotter.get
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
