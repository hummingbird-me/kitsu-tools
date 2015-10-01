module DoorkeeperHelpers
  extend ActiveSupport::Concern

  ##
  # Renders a current_user
  def current_user
    User.find(doorkeeper_token.resource_owner_id) if doorkeeper_token
  end

  ##
  # Return boolean representing whether there is a user signed in
  def signed_in?
    !!current_user
  end
end
