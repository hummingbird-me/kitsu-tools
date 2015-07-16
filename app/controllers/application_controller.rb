require_dependency 'auth/helpers'

class ApplicationController < ActionController::Base
  force_ssl if Rails.env.production?
  protect_from_forgery

  before_filter :check_user_authentication, :preload_objects
  before_filter :production_profiler
  before_filter :configure_permitted_parameters, if: :devise_controller?

  include Auth::Helpers

  rescue_from 'Auth::UnauthorizedException' do
    respond_to do |format|
      format.json { render json: { error: 'Not authenticated' }, status: 403 }
      format.html { redirect_to(new_user_session_path) }
    end
  end

  def production_profiler
    if user_signed_in? && current_user.admin?
      Rack::MiniProfiler.authorize_request
    end
  end

  # Send an object along with the initial HTML response that will be loaded into
  # Ember Data's cache.
  def preload_to_ember!(data, options = {})
    @preload ||= []
    data = ed_serialize(data, options)
    @preload << data unless data.nil?
  end

  def ed_serialize(data, options = {})
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

  def preload_objects
    # Preload current user.
    if user_signed_in?
      preload_to_ember! current_user, serializer: CurrentUserSerializer,
                                      root: :current_users
    end

    # Preload blotter.
    generic_preload! 'blotter', Blotter.get

    # Preload stripe publishable key.
    generic_preload! 'stripe_key', Rails.configuration.stripe[:publishable_key]

    # Preload supported emoji
    generic_preload! 'emoji', Twemoji::CODES
  end

  # Render the Ember application, optionally preloading some data into ED
  def render_ember(data = nil)
    preload_to_ember! data if data
    render 'layouts/redesign', layout: false
  end

  # Shortcut to respond with JSON or the Ember application w/ preloaded data
  def respond_with_ember(data, accept_json = true)
    respond_to do |format|
      format.html { render_ember data }
      format.json { render json: data } if accept_json
    end
  end

  # Creates a controller action which does a "default" Ember rendering
  def self.ember_action(action_name, accept_json = false, &block)
    if block_given?
      define_method(action_name.to_sym) do
        respond_with_ember(instance_eval(&block), accept_json)
      end
    else
      define_method(action_name.to_sym) do
        render_ember
      end
    end
  end

  # Save and render
  def save_and_render(model)
    if model.save
      render json: model
    else
      error! model.errors.to_h, 422
    end
  end

  # Render a JSON error with the given error message and status code.
  # Accepts parameters in either order for legacy reasons.
  # Advised parameter order is status, message
  def error!(status, message)
    # Flip the params if status isn't a number
    status, message = message, status unless status.is_a?(Fixnum)
    # If the message is a Hash of errors, we put it in standard ED form
    if message.is_a?(Hash)
      render json: { errors: message }, status: status
    else
      render json: { error: message }, status: status
    end
  end

  # DEPRECATED
  def hide_cover_image; end

  def mixpanel
    if Rails.env.production?
      @mixpanel ||= Mixpanel::Tracker.new '92b66301c752642b40ca39e718517d94',
                                          async: true, env: request.env
    else
      require_dependency 'dummy_mixpanel'
      @mixpanel ||= DummyMixpanel.new
    end
    @mixpanel
  end

  def after_sign_in_path_for(resource)
    stored_location_for(resource) || user_path(resource)
  end

  def not_found!
    fail ActionController::RoutingError, 'Not Found'
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) << :name
  end
end
