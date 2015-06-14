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

require 'test_helper'

class ClientAuthorizationTest < ActiveSupport::TestCase
  # Explicitly set creator so we don't run into conflicts on Faker username
  let (:app) { build(:app, creator: users(:josh)) }

  test 'revocation works' do
    auth = build(:client_authorization, app: app)

    OAuth2::Token.expects(:revoke!).with(auth.user, auth.app).once
    auth.expects(:destroy).once
    auth.revoke!
  end

  test 'has_scope? returns false for unauthorized scopes' do
    auth = build(:client_authorization, app: app, scopes: %w[kirito asuna])

    refute auth.has_scope?(:lisbeth), 'Expected has_scope? to return false'
  end

  test 'has_scope? returns true for authorized scopes' do
    auth = build(:client_authorization, app: app, scopes: %w[kirito asuna])

    assert auth.has_scope?(:kirito), 'Expected has_scope? to return true'
  end

  test 'has_scope? returns true when authorized for all scopes' do
    auth = build(:client_authorization, app: app, scopes: %w[all])

    assert auth.has_scope?(:leafa), 'Expected has_scope? to return true'
  end

  test 'has_scopes? returns false if not all scopes are authorized' do
    auth = build(:client_authorization, app: app, scopes: %w[kirito asuna])

    refute auth.has_scopes?(%w[lisbeth asuna]),
           'Expected has_scopes? to return true'
  end
end
