import { test } from 'qunit';
import moduleForAcceptance from 'client/tests/helpers/module-for-acceptance';
import { authenticateSession, invalidateSession } from 'client/tests/helpers/ember-simple-auth';

moduleForAcceptance('Acceptance | routing');

test('visiting `/dashboard` redirects to `/`', function(assert) {
  assert.expect(1);
  visit('/dashboard');
  andThen(() => assert.equal(currentURL(), '/'));
});

test('visiting `/` works when unauthenticated', function(assert) {
  assert.expect(1);
  invalidateSession(this.application);
  visit('/');
  andThen(() => assert.equal(currentURL(), '/'));
});

test('visiting `/sign-in` redirects to `/` when authenticated', function(assert) {
  assert.expect(1);
  authenticateSession(this.application);
  visit('/sign-in');
  andThen(() => assert.equal(currentURL(), '/'));
});

test('visiting `/sign-in` works when unauthenticated', function(assert) {
  assert.expect(1);
  invalidateSession(this.application);
  visit('/sign-in');
  andThen(() => assert.equal(currentURL(), '/sign-in'));
});

test('visiting `/sign-up` redirects to `/` when authenticated', function(assert) {
  assert.expect(1);
  authenticateSession(this.application);
  visit('/sign-up');
  andThen(() => assert.equal(currentURL(), '/'));
});

test('visiting `/sign-up` works when unauthenticated', function(assert) {
  assert.expect(1);
  invalidateSession(this.application);
  visit('/sign-up');
  andThen(() => assert.equal(currentURL(), '/sign-up'));
});

test('visiting `/onboarding` redirects to `/sign-in` when unauthenticated', function(assert) {
  assert.expect(1);
  invalidateSession(this.application);
  visit('/onboarding');
  andThen(() => assert.equal(currentURL(), '/sign-in'));
});

test('visiting an unknown route redirects to `/404`', function(assert) {
  assert.expect(2);
  visit('/doesnt-exist');
  andThen(() => assert.equal(currentRouteName(), 'not-found'));
  andThen(() => assert.equal(currentURL(), '/404'));
});
