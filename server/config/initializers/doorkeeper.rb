Doorkeeper.configure do
  orm :active_record

  # => Authentication
  # Check whether the resource owner is authenticated or not.
  resource_owner_authenticator do
    # TODO: write error! method
    User.find(doorkeeper_token[:resource_owner_id]) || error!
  end
  # Authenticate in Resource Owner Password flow
  resource_owner_from_credentials do
    user = User.find_for_auth(params[:username])
    user if user && user.valid_password?(params[:password])
  end
  # Restrict access to the web interface for adding oauth applications
  admin_authenticator do
    # TODO: write error! method and use Pundit
    User.find(doorkeeper_token[:resource_owner_id])
  end

  # => Token Configuration
  access_token_expires_in 30.days # Expire access tokens
  reuse_access_token # Reuse access tokens if possible
  use_refresh_token # Issue refresh tokens

  # => Application Registration
  # Require an owner for each application
  # Note: you must also run the rails g doorkeeper:application_owner generator
  # to provide the necessary support
  enable_application_owner confirmation: true

  # => Available Scopes
  default_scopes :public
  optional_scopes :everything

  # Change the native redirect uri for client apps
  # When clients register with the following redirect uri, they won't be
  # redirected to any server and the authorization code will be displayed within
  # the provider.  The value can be any string. Use nil to disable this feature.
  # When disabled, clients must provide a valid URL
  # (Similar behaviour: https://developers.google.com/accounts/docs/OAuth2InstalledApp#choosingredirecturi)
  #
  # native_redirect_uri 'urn:ietf:wg:oauth:2.0:oob'

  # Force SSL for redirect URI
  force_ssl_in_redirect_uri !Rails.env.development?

  # implicit and password grant flows have risks that you should understand
  # before enabling:
  #   http://tools.ietf.org/html/rfc6819#section-4.4.2
  #   http://tools.ietf.org/html/rfc6819#section-4.4.3
  #
  grant_flows %w[authorization_code client_credentials implicit password]

  # Under some circumstances you might want to have applications auto-approved,
  # so that the user skips the authorization step.
  # For example if dealing with a trusted application.
  # skip_authorization do |resource_owner, client|
  #   client.superapp? or resource_owner.admin?
  # end

  # WWW-Authenticate Realm
  realm 'Hummingbird'
end
