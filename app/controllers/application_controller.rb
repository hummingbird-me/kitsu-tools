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

  # Upgrade from auth_token to token by signing them in again
  def upgrade_token!
    if user_signed_in?
      user = User.find_by(authentication_token: cookies[:auth_token])
      sign_in user
    end
  end

  def token_payload
    JWT.decode(cookies[:token], ENV["JWT_SECRET"])[0]
  end

  # Override the Devise junk if the user has already been upgraded
  def current_user
    if cookies[:token]
      User.find(token_payload['user'])
    else
      super
    end
  rescue JWT::DecodeError, JWT::ExpiredSignature
    nil
  end

  def user_signed_in?
    if cookies[:token]
      !!current_user
    else
      super
    end
  end

  def authenticate_user!
    if cookies[:token]
      unless user_signed_in?
        error! 'Not authenticated', 403
      end
    else
      super
    end
  end

  # Upgrades the token, refreshes it, and clears invalid ones
  def check_user_authentication
    if cookies[:token]
      if !user_signed_in?
        sign_out :user
      else
        # refresh the token if it's gonna expire in less than a month
        sign_in current_user if token_payload['exp'] - Time.now.to_i > 1.month

        # Update the ip addresses
        if current_user.current_sign_in_ip != request.remote_ip
          current_user.update_attributes!(
            current_sign_in_ip: request.remote_ip,
            last_sign_in_ip: current_user.current_sign_in_ip
          )
        end
      end
    elsif cookies[:auth_token]
      user = User.find_by(authentication_token: cookies[:auth_token])
      if user && user.current_sign_in_ip != request.remote_ip
        user.update_column :last_sign_in_ip, user.current_sign_in_ip
        user.update_column :current_sign_in_ip, request.remote_ip
      end
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
