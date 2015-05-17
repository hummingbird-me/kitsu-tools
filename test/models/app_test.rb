class AppTest < ActiveSupport::TestCase
  test '#redirect_allowed?' do
    app = build(:app, redirect_uri: 'https://example.com/oauth/hummingbird')
    refute app.redirect_allowed?('https://every.villian.is.lemons/')
    assert app.redirect_allowed?('https://example.com/oauth/hummingbird')
  end

  test '#scope_allowed? in general case' do
    app = build(:app)
    assert app.scope_allowed?(:public_profile)
    refute app.scope_allowed?(:evil)
  end

  test '#scopes_allowed? in privileged case' do
    app = build(:app, privileged: true)
    assert app.scope_allowed?(:all)
    refute app.scope_allowed?(:evil)
  end

  test '#build_redirect_uri for fragment' do
    app = build(:app, redirect_uri: 'https://example.com/')
    assert_equal 'https://example.com/#foo=bar',
                 app.build_redirect_uri(:fragment, {foo: 'bar'})
  end

  test '#build_redirect for query_string' do
    app = build(:app, redirect_uri: 'https://example.com/')
    assert_equal 'https://example.com/?foo=bar',
                 app.build_redirect_uri(:query_string, {foo: 'bar'})
  end

  test 'Fails validation if redirect_uri is HTTP' do
    app = build(:app, {
      creator: users(:josh),
      write_access: true,
      redirect_uri: 'http://example.com/oauth/hummingbird'
    })
    refute app.valid?
  end

  test 'Fails validation if redirect_uri has a fragment' do
    app = build(:app, {
      creator: users(:josh),
      write_access: true,
      redirect_uri: 'https://example.com/oauth/hummingbird#fragment'
    })
    refute app.valid?
  end
end
