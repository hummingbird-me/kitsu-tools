import { test } from 'qunit';
import moduleForAcceptance from 'client/tests/helpers/module-for-acceptance';

moduleForAcceptance('Acceptance | users');

test('visiting `user.*` with an id redirects to the named route', function(assert) {
  assert.expect(1);
  const user = server.create('user');
  visit(`/users/${user.id}`);
  andThen(() => assert.equal(currentURL(), `/users/${user.name}`));
});
