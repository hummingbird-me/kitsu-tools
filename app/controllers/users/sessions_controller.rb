class Users::SessionsController < Devise::SessionsController
  def new
    session["user_return_to"] = request.referer
    self.resource = build_resource(nil, :unsafe => true)
    clean_up_passwords(resource)
    if params[:return_to]
      redirect_to params[:return_to]
    else
      respond_with(resource, serialize_options(resource))
    end
  end
end
