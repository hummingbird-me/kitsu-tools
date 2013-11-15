class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :authenticate_user_from_token_cookie!

  # Send an object along with the initial HTML response so that Ember will not need
  # to make additional requests to fetch data.
  def preload!(key, data)
    @preload ||= []
    data = [data] unless data.is_a? Array
    @preload.push({object_type: key, object: ActiveModel::ArraySerializer.new(data, scope: current_user, root: key.pluralize)})
  end

  # Authenticate users *only* via the auth_token cookie.
  def authenticate_user_from_token_cookie!
    auth_token = Rack::Request.new(env).cookies['auth_token']
    if auth_token
      user = User.where(authentication_token: auth_token).first
      if user
        sign_in(user, store: false)
        preload! "user", user
        return
      end
    end
    # If there is auth_token cookie but the user is signed in through the Devise
    # session cookie, sign them out.
    sign_out(current_user) if user_signed_in?
  end

  def render_ember
    render "layouts/redesign", layout: false
  end

  ### PRE-EMBER CODE BELOW -- NEEDS REWRITING.

  before_filter :admin_check, :user_last_seen

  def admin_check
    if user_signed_in? and current_user.admin? and current_user.id == 1
      Rack::MiniProfiler.authorize_request
    end
  end

  def user_last_seen
    if user_signed_in?
      $redis.hset("user_last_seen", current_user.id.to_s, Time.now.to_i)
    end
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
    stored_location_for(resource) || user_path(resource)
  end

  def after_sign_out_path_for(resource)
    request.referrer
  end

  # Can the user view NSFW posts in the forum?
  def can_view_nsfw_forum_content?
    user_signed_in? and ((not current_user.sfw_filter) or current_user.admin?)
  end
  helper_method :can_view_nsfw_forum_content?

  def not_found!
    raise ActionController::RoutingError.new('Not Found')
  end
end
