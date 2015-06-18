require 'test_helper'

class OAuth2::TokenControllerTest < ActionController::TestCase
  let(:owner) { users(:josh) }
  let(:app) do
    create(:app, {
      write_access: true,
      creator: owner,
      redirect_uri: 'https://example.com/oauth/hummingbird',
      privileged: true
    })
  end
  let(:other_app) do
    create(:app, {
      write_access: true,
      creator: owner,
      redirect_uri: 'https://example.com/oauth/hummingbird',
      privileged: true
    })
  end

  test 'fails when given an invalid client secret' do
    basic_auth(app.key, 'hamburgers')
    code = OAuth2::Code.new(owner, app, %w[all])
    post :token, {
      grant_type: 'authorization_code',
      code: code.encode,
      redirect_uri: app.redirect_uri
    }
    assert_response 401
    assert_error_response :invalid_client
  end

  test 'authorization_code grant with valid code' do
    as_app(app)
    code = OAuth2::Code.new(owner, app, %w[all])
    post :token, {
      grant_type: 'authorization_code',
      code: code.encode,
      redirect_uri: app.redirect_uri
    }
    assert_token_response
  end

  test 'authorization_code grant with invalid code' do
    as_app(app)
    code = OAuth2::Code.new(owner, app, %w[all])
    Timecop.travel(10.minutes.from_now) do
      post :token, {
        grant_type: 'authorization_code',
        code: code.encode,
        redirect_uri: app.redirect_uri
      }
    end
    assert_error_response :invalid_grant
  end

  test 'authorization_code grant with incorrect client' do
    as_app(app)
    code = OAuth2::Code.new(owner, other_app, %w[all])
    post :token, {
      grant_type: 'authorization_code',
      code: code.encode,
      redirect_uri: app.redirect_uri
    }
    assert_error_response :unauthorized_client
  end

  test 'authorization_code grant with invalid redirect_uri' do
    flunk
  end

  test 'refresh_token grant with valid token' do
    as_app(app)
    token = OAuth2::RefreshToken.new(owner, app, %w[all])
    post :token, {
      grant_type: 'refresh_token',
      refresh_token: token.encode
    }
    assert_token_response
  end

  test 'refresh_token grant with invalid token' do
    as_app(app)
    token = OAuth2::RefreshToken.new(owner, app, %w[all])
    Timecop.travel(10.years.from_now) do
      post :token, {
        grant_type: 'refresh_token',
        refresh_token: token.encode
      }
    end
    assert_error_response :invalid_grant
  end

  test 'refresh_token grant with mismatched client' do
    as_app(app)
    token = OAuth2::RefreshToken.new(owner, other_app, %w[all])
    post :token, {
      grant_type: 'refresh_token',
      refresh_token: token.encode
    }
    assert_error_response :unauthorized_client
  end

  test 'password grant with valid username and password' do
    flunk
  end

  test 'password grant with valid username and invalid password' do
    flunk
  end

  test 'password grant with valid email and password' do
    flunk
  end

  test 'client credentials grant just errors out' do
    as_app(app)
    post :token, {
      grant_type: 'client_credentials'
    }
    assert_error_response :unsupported_grant_type
  end

  test 'unknown grant type just errors out' do
    as_app(app)
    post :token, {
      grant_type: 'omelette'
    }
    assert_error_response :unsupported_grant_type
  end

  def basic_auth(user, pass)
    @request.env['HTTP_AUTHORIZATION'] =
      ActionController::HttpAuthentication::Basic.encode_credentials(user, pass)
  end

  def as_app(app)
    basic_auth(app.key, app.secret)
  end

  def assert_token_response
    assert_response 200
    assert_json_body({
      access_token: String,
      expires_in: Fixnum,
      scope: String,
      token_type: 'bearer'
    })
  end

  def assert_error_response(err = String)
    assert_json_body({
      error: err.to_s
    })
  end
end
