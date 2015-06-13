require 'test_helper'

Hummingbird::Application.config.jwt_secret = 'TEST'

class TokenTest < ActiveSupport::TestCase
  let(:josh) { users(:josh) }

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
