module AuthenticatedResource
  extend ActiveSupport::Concern

  # Get current user from context
  def current_user
    @context[:user]
  end
end
