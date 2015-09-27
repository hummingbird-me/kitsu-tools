import Ember from 'ember';
import { module, test } from 'qunit';
import startApp from 'client/tests/helpers/start-app';
import { authenticateSession, invalidateSession } from 'client/tests/helpers/ember-simple-auth';

module('Acceptance | routes', {
  beforeEach() {
    this.application = startApp();
  },

  afterEach() {
    Ember.run(this.application, 'destroy');
  }
});

test('visiting /dashboard should redirect', function(assert) {
  assert.expect(1);
  visit('/dashboard');

  andThen(() => assert.notEqual(currentURL(), '/dashboard'));
});

test('visiting / should work if unauthenticated', function(assert) {
  assert.expect(1);
  invalidateSession(this.application);
  visit('/');

  andThen(() => assert.equal(currentURL(), '/'));
});

test('visiting /sign-in should redirect if authenticated', function(assert) {
  assert.expect(1);
  authenticateSession(this.application);
  visit('/sign-in');

  andThen(() => assert.notEqual(currentURL(), '/sign-in'));
});

test('visiting /sign-in should work if unauthenticated', function(assert) {
  assert.expect(1);
  invalidateSession(this.application);
  visit('/sign-in');

  andThen(() => assert.equal(currentURL(), '/sign-in'));
});

test('visiting /sign-up should redirect if authenticated', function(assert) {
  assert.expect(1);
  authenticateSession(this.application);
  visit('/sign-up');

  andThen(() => assert.notEqual(currentURL(), '/sign-up'));
});

test('visiting /sign-up should work if unauthenticated', function(assert) {
  assert.expect(1);
  invalidateSession(this.application);
  visit('/sign-up');

  andThen(() => assert.equal(currentURL(), '/sign-up'));
});
