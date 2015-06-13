require 'test_helper'

Hummingbird::Application.config.jwt_secret = 'TEST'

class TokenTest < ActiveSupport::TestCase
  let(:josh) { users(:josh) }

  test 'should parse a token with oauth2_code scope into OAuth2::Code' do
    token_str = Token.new(josh, scope: ['oauth2_code']).encode
    token = Token.parse(token_str)

    assert_instance_of OAuth2::Code, token
  end

  test 'should parse a token with client_id into OAuth2::Token' do
    token_str = Token.new(josh, client_id: 5).encode
    token = Token.parse(token_str)

    assert_instance_of OAuth2::Token, token
  end

  test 'should parse a nil token into an invalid Token instance' do
    token = Token.parse(nil)

    assert_instance_of Token, token
    assert token.invalid?
  end

  test 'should parse a normal token into generic Token' do
    token_str = Token.new(josh).encode
    token = Token.parse(token_str)

    assert_instance_of Token, token
  end

  test 'decode factory method should return instance with payload' do
    token_str = Token.new(josh).encode
    token = Token.decode(token_str)

    refute_nil token.instance_variable_get(:@payload)
    assert_instance_of Token, token
  end

  test "should notice and nil users and scopes when it's invalid" do
    token_str = Token.new(josh).encode
    Hummingbird::Application.config.jwt_secret = 'shut up'
    token = Token.decode(token_str)
    Hummingbird::Application.config.jwt_secret = 'TEST'

    refute token.valid?, 'Should not be valid'
    assert_nil token.has_scope?('badgers'), 'Scopes should be nil'
    assert_nil token.user, 'User should be nil'
  end

  test "should notice when it's expired" do
    token = Token.new(josh, exp: 5.minutes.ago)

    assert token.expired?, 'Should be expired'
    refute token.valid?, 'Should not be valid'
  end

  test "should notice when it's revoked" do
    token = Token.new(josh)
    token.revoke!

    assert token.revoked?, 'Should be revoked'
    refute token.valid?, 'Should not be valid'
  end

  test 'should limit on normal scopes' do
    token = Token.new(josh, scope: %w{forum library})

    assert token.has_scope?('library'), 'Should have library scope'
    refute token.has_scope?('profile'), 'Should not have profile scope'
  end

  test 'should bow down to the global scope' do
    token = Token.new(josh, scope: %w{all})

    assert token.has_scope?('library'), 'Should have library scope'
    assert token.has_scope?('badgers'), 'Should have badgers scope'
  end

  test 'will find the user by token' do
    token = Token.new(josh)
    assert_equal josh, token.user
  end

  test 'reissue a token' do
    token_a = Token.new(josh)
    token_b = token_a.reissue

    assert_equal token_a.user, token_b.user
    assert_equal token_a.scopes, token_b.scopes
  end
end
