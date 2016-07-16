module DoorkeeperHelpers
  extend ActiveSupport::Concern

  # Returns the current user
  def current_user
    User.find(doorkeeper_token.resource_owner_id) if doorkeeper_token
  end

  # Return boolean representing whether there is a user signed in
  def signed_in?
    current_user.present?
  end

  # Provide context of current user to JR
  def context
    { user: current_user }
  end
end
