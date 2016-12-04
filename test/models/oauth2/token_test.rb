require 'test_helper'

Hummingbird::Application.config.jwt_secret = 'TEST'

class OAuth2::TokenTest < ActiveSupport::TestCase
  let(:user) { users(:josh) }
  let(:client) do
    create(:app, {
      creator: user,
      redirect_uri: 'https://example.com/oauth/hummingbird',
      write_access: true
    })
  end

  test 'should convert from an OAuth2::Code' do
    code = OAuth2::Code.new(user, client, %w(test))
    token = OAuth2::Token.from_code(code)

    assert_instance_of OAuth2::Token, token
    assert_equal token.instance_variable_get(:@payload)['scope'],
                 code.instance_variable_get(:@payload)['token_scopes']
    assert code.invalid?
  end

  test '#client' do
    token = OAuth2::Token.new(user, client, %i[test])
    assert_equal client, token.client
  end

  test 'should revoke by client+user' do
    token = OAuth2::Token.new(user, client, %i[test])
    Timecop.freeze(2.seconds.from_now) do
      OAuth2::Token.revoke!(user, client)
      assert token.revoked?
    end
  end
end

