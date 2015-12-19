import Ember from 'ember';
import { module, test } from 'qunit';
import startApp from 'client/tests/helpers/start-app';
import Pretender from 'pretender';
import { currentSession } from 'client/tests/helpers/ember-simple-auth';

module('Acceptance | authentication', {
  beforeEach() {
    this.application = startApp();
    this.server = new Pretender();
  },

  afterEach() {
    Ember.tryInvoke(this.server, 'shutdown');
    Ember.run(this.application, 'destroy');
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
