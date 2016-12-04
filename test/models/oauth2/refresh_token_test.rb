require 'test_helper'

Hummingbird::Application.config.jwt_secret = 'TEST'

class OAuth2::RefreshTokenTest < ActiveSupport::TestCase
  let(:user) { users(:josh) }
  let(:client) do
    create(:app, {
      creator: user,
      redirect_uri: 'https://example.com/oauth/hummingbird',
      write_access: true
    })
  end

  test 'should expire in 6 months' do
    Timecop.freeze(Date.today) do
      code = OAuth2::RefreshToken.new(user, client, %i[all])
      assert_equal 6.months, code.expires_in
    end
  end

  test 'should expose token scopes' do
    code = OAuth2::RefreshToken.new(user, client, %i[all])
    assert_equal %i[all], code.token_scopes
  end

  test 'should have only oauth2_refresh scope' do
    code = OAuth2::RefreshToken.new(user, client, %i[all])
    assert_equal %i[oauth2_refresh], code.scopes
  end
end
