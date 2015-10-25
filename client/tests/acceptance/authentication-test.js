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

test('/sign-up flow works', function(assert) {
  assert.expect(3);

  this.server.post('/oauth/token', () => [200, {}, '{ "test_valid": true }']);
  this.server.post('/users', () => [200, {} , '{ "data": { "type": "users", "id": "1" } }']);

  visit('/sign-up');
  fillIn('input[data-test-selector="email"]', 'a@b.com');
  fillIn('input[data-test-selector="username"]', 'vevix');
  fillIn('input[data-test-selector="password"]', 'password');
  click('button[data-test-selector="sign-up"]');

  andThen(() => {
    const session = currentSession(this.application);
    assert.equal(currentURL(), '/onboarding/start', 'user was redirected to onboarding');
    assert.ok(session.get('isAuthenticated'), 'session is authenticated');
    assert.ok(session.get('data.authenticated.test_valid'), 'session received and stored data');
  });
});

test('/sign-in flow works', function(assert) {
  assert.expect(3);

  this.server.post('/oauth/token', () => [200, {}, '{ "test_valid": true }']);

  visit('/sign-in');
  fillIn('input[data-test-selector="identification"]', 'username');
  fillIn('input[data-test-selector="password"]', 'password');
  click('button[data-test-selector="sign-in"]');

  andThen(() => {
    const session = currentSession(this.application);
    assert.equal(currentURL(), '/', 'user was redirected to the dashboard');
    assert.ok(session.get('isAuthenticated'), 'session is authenticated');
    assert.ok(session.get('data.authenticated.test_valid'), 'session received and stored data');
  });
});
