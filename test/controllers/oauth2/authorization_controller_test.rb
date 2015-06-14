require 'test_helper'

class OAuth2::AuthorizationControllerTest < ActionController::TestCase
  let(:owner) { users(:josh) }
  let(:app) do
    create(:app, {
      write_access: true,
      creator: owner,
      redirect_uri: 'https://example.com/oauth/hummingbird',
      privileged: true
    })
  end

  test 'Request page renders with proper parameters' do
    get :ask, {
      client_id: app.key,
      redirect_uri: 'https://example.com/oauth/hummingbird',
      scope: 'all',
      response_type: 'code'
    }
    assert_response 200
    assert_template :ask
  end

  test 'Request page errors out when the client is nonexistent' do
    get :ask, client_id: 523
    assert_response 400
    assert_template :error
    assert_equal :invalid_client, assigns(:error)
  end

  test 'Request page errors out when readonly client is presented' do
    readonly_app = create(:app, creator: owner)
    get :ask, client_id: readonly_app.key
    assert_response 400
    assert_template :error
    assert_equal :readonly_client, assigns(:error)
  end

  test 'Request page errors out when an invalid redirect is requested' do
    get :ask, {
      client_id: app.key,
      redirect_uri: 'https://every.villian.is.lemons/',
      scope: 'all',
      response_type: 'code'
    }
    assert_response 400
    assert_template :error
    assert_equal :invalid_redirect, assigns(:error)
  end

  test 'Request page errors out for an unsupported response type' do
    get :ask, {
      client_id: app.key,
      redirect_uri: app.redirect_uri,
      scope: 'all',
      response_type: 'hotdogs'
    }
    assert_response 302
    assert_redirected_to app.redirect_uri + '?error=unsupported_response_type'
  end

  test 'Request page errors out for an invalid scope' do
    get :ask, {
      client_id: app.key,
      redirect_uri: app.redirect_uri,
      scope: 'dead_people',
      response_type: 'code'
    }
    assert_response 302
    assert_redirected_to app.redirect_uri + '?error=invalid_scope'
  end

  test 'Request page errors out for an unprivileged app using all scope' do
    app.update_attributes(privileged: false)
    get :ask, {
      client_id: app.key,
      redirect_uri: app.redirect_uri,
      scope: 'all',
      response_type: 'code'
    }
    assert_response 302
    assert_redirected_to app.redirect_uri + '?error=invalid_scope'
  end
end
