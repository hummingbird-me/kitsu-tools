# == Schema Information
#
# Table name: client_authorizations
#
#  id         :integer          not null, primary key
#  scopes     :string(255)      default([]), not null, is an Array
#  app_id     :integer
#  user_id    :integer
#  created_at :datetime
#  updated_at :datetime
#

class ClientAuthorization < ActiveRecord::Base
  belongs_to :app
  belongs_to :user

  def revoke!
    OAuth2::Token.revoke!(user, app)
    destroy
  end

  def has_scope?(scope)
    return true if scopes.include?('all')
    scopes.include?(scope.to_s)
  end

  def has_scopes?(scopes)
    scopes.all? { |x| has_scope?(x) }
  end
end
