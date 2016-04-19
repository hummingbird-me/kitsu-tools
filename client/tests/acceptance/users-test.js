import { tryInvoke } from 'ember-utils';
import { test } from 'qunit';
import moduleForAcceptance from 'client/tests/helpers/module-for-acceptance';
import Pretender from 'pretender';

moduleForAcceptance('Acceptance | users', {
  beforeEach() {
    this.server = new Pretender();
  },

  afterEach() {
    tryInvoke(this.server, 'shutdown');
  }
});

test('visiting `user.*` with an id redirects to the named route', function(assert) {
  assert.expect(1);
  const data = {
    type: 'users',
    id: '1',
    attributes: {
      name: 'holo'
    }
  };
  this.server.get('/api/edge/users/1', () => [200, {}, JSON.stringify({ data })]);
  this.server.get('/api/edge/users', () => [200, {}, JSON.stringify({ data: [data] })]);

  visit('/users/1');
  andThen(() => assert.equal(currentURL(), '/users/holo'));
});
