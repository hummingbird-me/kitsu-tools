require 'test_helper'

Hummingbird::Application.config.jwt_secret = 'TEST'

class OAuth2::CodeTest < ActiveSupport::TestCase
  let(:user) { users(:josh) }
  let(:client) do
    create(:app, {
      creator: user,
      redirect_uri: 'https://example.com/oauth/hummingbird',
      write_access: true
    })
  end

  test 'should expire in 5 minutes' do
    Timecop.freeze(Date.today) do
      code = OAuth2::Code.new(user, client, %i[all])
      assert_equal 5.minutes, code.expires_in
    end
  end

  test 'should expose token scopes' do
    code = OAuth2::Code.new(user, client, %i[all])
    assert_equal %i[all], code.token_scopes
  end

  test 'should have only oauth2_code scope' do
    code = OAuth2::Code.new(user, client, %i[all])
    assert_equal %i[oauth2_code], code.scopes
  end
end
