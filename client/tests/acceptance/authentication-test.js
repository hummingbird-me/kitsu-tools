import { tryInvoke } from 'ember-utils';
import { test } from 'qunit';
import moduleForAcceptance from 'client/tests/helpers/module-for-acceptance';
import Pretender from 'pretender';
import { currentSession } from 'client/tests/helpers/ember-simple-auth';

moduleForAcceptance('Acceptance | authentication', {
  beforeEach() {
    this.server = new Pretender();
  },

  afterEach() {
    tryInvoke(this.server, 'shutdown');
  }
});

test('creating an account works', function(assert) {
  assert.expect(2);
  this.server.post('/users', () => {
    const data = {
      type: 'users',
      id: 1
    };
    return [200, {}, JSON.stringify({ data })];
  });
  this.server.post('/oauth/token', () => [200, {}, '{}']);

  visit('/sign-up');
  fillIn('input[data-test-selector="email"]', 'email@host.tld');
  fillIn('input[data-test-selector="username"]', 'username');
  fillIn('input[data-test-selector="password"]', 'password');
  click('button[data-test-selector="sign-up"]');

  andThen(() => {
    const session = currentSession(this.application);
    assert.ok(session.get('isAuthenticated'), 'session is authenticated');
    assert.equal(currentURL(), '/onboarding/start', 'user was redirected to onboarding');
  });
});

test('signing in works', function(assert) {
  assert.expect(2);
  this.server.post('/oauth/token', () => [200, {}, '{}']);

  visit('/sign-in');
  fillIn('input[data-test-selector="identification"]', 'username');
  fillIn('input[data-test-selector="password"]', 'password');
  click('button[data-test-selector="sign-in"]');

  andThen(() => {
    const session = currentSession(this.application);
    assert.ok(session.get('isAuthenticated'), 'session is authenticated');
    assert.equal(currentURL(), '/', 'user was redirected to the dashboard');
  });
});
