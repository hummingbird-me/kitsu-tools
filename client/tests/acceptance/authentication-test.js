import { test } from 'qunit';
import moduleForAcceptance from 'client/tests/helpers/module-for-acceptance';
import { currentSession } from 'client/tests/helpers/ember-simple-auth';
import { Response } from 'ember-cli-mirage';
import testSelector from 'client/tests/helpers/ember-test-selectors';

moduleForAcceptance('Acceptance | Authentication');

test('I should be able to create an account', function(assert) {
  assert.expect(3);

  visit('/sign-up');
  fillIn(testSelector('selector', 'email'), 'bob@acme.com');
  fillIn(testSelector('selector', 'username'), 'bob');
  fillIn(testSelector('selector', 'password'), 'password');
  click(testSelector('selector', 'sign-up'));

  andThen(() => {
    const session = currentSession(this.application);
    assert.ok(session.get('isAuthenticated'));
    assert.equal(currentURL(), '/onboarding/start');
    assert.equal(server.db.users[0].email, 'bob@acme.com');
  });
});

test('I should see an error message when validation fails', function(assert) {
  assert.expect(2);
  server.post('/users', ({ users }, request) => {
    const params = JSON.parse(request.requestBody);
    const { attributes } = params.data;
    const records = users.where({ email: attributes.email }).models.length > 0;
    const response = new Response(400, {}, {
      errors: [{ detail: 'email is already taken.' }]
    });
    return records === true ? response : users.create(attributes);
  });
  server.create('user', { email: 'bob@acme.com' });

  visit('/sign-up');
  fillIn(testSelector('selector', 'email'), 'bob@acme.com'); // will fail!
  fillIn(testSelector('selector', 'username'), 'bob');
  fillIn(testSelector('selector', 'password'), 'password');
  click(testSelector('selector', 'sign-up'));

  andThen(() => {
    assert.equal(currentURL(), '/sign-up');
    const error = find(testSelector('selector', 'error-message')).text().trim();
    assert.equal(error, 'Email is already taken.');
  });
});

test('I should be able to sign in to my account', function(assert) {
  assert.expect(2);
  server.create('user', { name: 'bob', password: 'password' });

  visit('/sign-in');
  fillIn(testSelector('selector', 'identification'), 'bob');
  fillIn(testSelector('selector', 'password'), 'password');
  click(testSelector('selector', 'sign-in'));

  andThen(() => {
    const session = currentSession(this.application);
    assert.ok(session.get('isAuthenticated'));
    assert.equal(currentURL(), '/');
  });
});

test('I should see an error message when credentials are wrong', function(assert) {
  assert.expect(2);
  server.post('http://localhost:4201/api/oauth/token', () => {
    return new Response(400, {}, { error: 'invalid_grant' });
  });
  server.create('user', { name: 'bob', password: 'password' });

  visit('/sign-in');
  fillIn(testSelector('selector', 'identification'), 'bob');
  fillIn(testSelector('selector', 'password'), 'not_password');
  click(testSelector('selector', 'sign-in'));

  andThen(() => {
    assert.equal(currentURL(), '/sign-in');
    const error = find(testSelector('selector', 'error-message')).text().trim();
    assert.equal(error, 'The provided credentials are invalid.');
  });
});
