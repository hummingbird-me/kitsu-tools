require 'test_helper'

require_dependency 'auth/provider'

class Auth::ProviderTest < ActiveSupport::TestCase
  before do
    @env = {}
    @cookies = {}
  end
  let(:provider) { Auth::Provider.new(@env, @cookies) }
  let(:josh) { users(:josh) }

  test '#current_user with masquerade' do
    @env[Auth::Provider::MASQUERADE] = josh
    assert_equal provider.current_user, josh
  end

  test '#signed_in? with masquerade' do
    @env[Auth::Provider::MASQUERADE] = josh
    assert provider.signed_in?, 'Expected signed_in? to return true'
  end

  test '#current_user with token' do
    @cookies[Auth::Provider::TOKEN] = Token.new(josh).encode
    assert_equal provider.current_user, josh
  end

  test '#signed_in? with token' do
    @cookies[Auth::Provider::TOKEN] = Token.new(josh).encode
    assert_equal provider.current_user, josh
  end

  test '#current_user in negative case' do
    assert_nil provider.current_user
  end

  test '#signed_in? in negative case' do
    refute provider.signed_in?, 'Expected signed_in? to return false'
  end

  test '#issue_cookie' do
    token = Token.new(josh)
    provider.issue_cookie(token)
    assert_equal token.encode, @cookies[Auth::Provider::TOKEN][:value]
  end

  test '#scope? with signed in but no scope' do
    @cookies[Auth::Provider::TOKEN] = Token.new(josh, scope: []).encode
    refute provider.scope?(:site), 'Expected scope? to return false'
  end

  test '#scope? with signed in and scope' do
    @cookies[Auth::Provider::TOKEN] = Token.new(josh, scope: ['site']).encode
    assert provider.scope?(:site), 'Expected scope? to return true'
  end

  test '#scope? with masquerade' do
    @env[Auth::Provider::MASQUERADE] = josh.id
    assert provider.scope?(:site), 'Expected scope? to return true'
  end

  test '#sign_in' do
    provider.expects(:issue_cookie).with { |t| t.user == josh }.once
    provider.sign_in(josh)
  end

  test '#sign_out' do
    @cookies = mock
    @cookies.expects(:delete)
            .with(Auth::Provider::TOKEN, domain: :all)
            .once
    provider.sign_out
  end

  test '#reissue_cookie!' do
    @cookies[Auth::Provider::TOKEN] = Token.new(josh).encode
    provider.expects(:issue_cookie).with { |t| t.user == josh }.once
    provider.reissue_cookie!
  end
end
