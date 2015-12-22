import Ember from 'ember';
import { module, test } from 'qunit';
import startApp from 'client/tests/helpers/start-app';
import Pretender from 'pretender';

module('Acceptance | users', {
  beforeEach() {
    this.application = startApp();
    this.server = new Pretender();
  },

  afterEach() {
    Ember.tryInvoke(this.server, 'shutdown');
    Ember.run(this.application, 'destroy');
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
  this.server.get('/users/1', () => [200, {}, JSON.stringify({ data })]);
  this.server.get('/users', () => [200, {}, JSON.stringify({ data: [data] })]);

  visit('/users/1');
  andThen(() => assert.equal(currentURL(), '/users/holo'));
});
