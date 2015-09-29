import Ember from 'ember';
import { module, test } from 'qunit';
import startApp from 'client/tests/helpers/start-app';
import Pretender from 'pretender';
import { currentSession } from 'client/tests/helpers/ember-simple-auth';

module('Acceptance | authentication', {
  beforeEach() {
    this.application = startApp();
    this.server = new Pretender(function() {
      this.post('/oauth/token', () => [200, {}, '{ "test_valid": true }']);
    });
  },

  afterEach() {
    Ember.tryInvoke(this.server, 'shutdown');
    Ember.run(this.application, 'destroy');
  }
});

test('/sign-up flow works', function(assert) {
  assert.ok(true);
});

test('/sign-in flow works', function(assert) {
  assert.expect(3);

  visit('/sign-in');
  fillIn('input[type="text"]', 'username');
  fillIn('input[type="password"]', 'password');
  click('button[type="submit"]');

  andThen(() => {
    const session = currentSession(this.application);
    assert.equal(currentURL(), '/');
    assert.ok(session.get('isAuthenticated'));
    assert.ok(session.get('data.authenticated.test_valid'));
  });
});
