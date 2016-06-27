import { test } from 'qunit';
import moduleForAcceptance from 'client/tests/helpers/module-for-acceptance';
import { currentSession, authenticateSession } from 'client/tests/helpers/ember-simple-auth';
import { Response } from 'ember-cli-mirage';

moduleForAcceptance('Acceptance | authentication');

test('creating an account with valid data', function(assert) {
  assert.expect(3);
  visit('/sign-up');
  fillIn('input[data-test-selector="email"]', 'email@host.tld');
  fillIn('input[data-test-selector="username"]', 'username');
  fillIn('input[data-test-selector="password"]', 'password');
  click('button[data-test-selector="sign-up"]');

  andThen(() => {
    const session = currentSession(this.application);
    assert.ok(session.get('isAuthenticated'));
    assert.equal(currentURL(), '/onboarding/start');
    assert.equal(server.db.users[0].email, 'email@host.tld');
  });
});

test('creating an account with invalid data', function(assert) {
  assert.expect(4);
  // Override POST /users to respond with failure when user exists
  server.post('/users', ({ users }, request) => {
    const params = JSON.parse(request.requestBody);
    const { attributes } = params.data;
    const records = users.where({ email: attributes.email }).models.length > 0;
    const response = new Response(400, {}, {
      errors: [{ detail: 'email is already taken.' }]
    });
    return records === true ? response : users.create(attributes);
  });

  const user = server.create('user');
  visit('/sign-up');
  fillIn('input[data-test-selector="email"]', user.email);
  fillIn('input[data-test-selector="username"]', 'username');
  fillIn('input[data-test-selector="password"]', 'password');
  click('button[data-test-selector="sign-up"]');

  andThen(() => {
    assert.equal(currentURL(), '/sign-up');
    assert.equal(server.db.users.length, 1);
    const errors = find('[data-test-selector="error-message"]');
    assert.equal(errors.length, 1);
    assert.equal(errors.text().trim(), 'Email is already taken.');
  });
});

test('signing into an account with valid data', function(assert) {
  assert.expect(2);
  const user = server.create('user');
  visit('/sign-in');
  fillIn('input[data-test-selector="identification"]', user.name);
  fillIn('input[data-test-selector="password"]', user.password);
  click('button[data-test-selector="sign-in"]');

  andThen(() => {
    const session = currentSession(this.application);
    assert.ok(session.get('isAuthenticated'));
    assert.equal(currentURL(), '/');
  });
});

test('signing into an account with invalid data', function(assert) {
  assert.expect(3);
  server.post('http://localhost:4201/api/oauth/token', () => {
    return new Response(400, {}, { error: 'invalid_grant' });
  });

  const user = server.create('user');
  visit('/sign-in');
  fillIn('input[data-test-selector="identification"]', user.name);
  fillIn('input[data-test-selector="password"]', 'invalid');
  click('button[data-test-selector="sign-in"]');

  andThen(() => {
    assert.equal(currentURL(), '/sign-in');
    const errors = find('[data-test-selector="error-message"]');
    assert.equal(errors.length, 1);
    assert.equal(errors.text().trim(), 'The provided credentials are invalid.');
  });
});

test('invalidates the session on 401 API response', function(assert) {
  assert.expect(2);
  // override the mirage handler here for specific response
  server.get('/users', () => new Response(401, {}, {}));

  const user = server.create('user');
  authenticateSession(this.application);
  visit(`/users/${user.name}`);
  andThen(() => {
    const session = currentSession(this.application);
    assert.equal(currentURL(), '/');
    assert.notOk(session.get('isAuthenticated'));
  });
});
