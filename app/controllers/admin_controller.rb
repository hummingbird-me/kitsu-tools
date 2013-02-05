class AdminController < ApplicationController
  
  before_filter :allow_only_admins
  def allow_only_admins
    # This shouldn't be needed becuse we also check for admin-ness in the routes.
    # Still doing this just to be safe. 
    authenticate_user!
    if not current_user.admin?
      raise ActionController::RoutingError.new('Not Found')
    end
  end
  
  def index
  end
end
