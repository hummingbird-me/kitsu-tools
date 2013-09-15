class OauthController < ApplicationController
  doorkeeper_for :all
  respond_to     :json

  def me
    me = current_resource_owner
    render :json => {
      name: me.name,
      email: me.email
    }
  end

  private
  def current_resource_owner
    User.find(doorkeeper_token.resource_owner_id) if doorkeeper_token
  end
end
