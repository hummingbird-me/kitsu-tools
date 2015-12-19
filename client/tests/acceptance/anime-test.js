import Ember from 'ember';
import { module, test } from 'qunit';
import startApp from 'client/tests/helpers/start-app';
import Pretender from 'pretender';

module('Acceptance | anime', {
  beforeEach() {
    this.application = startApp();
    this.server = new Pretender();
  },

  afterEach() {
    Ember.tryInvoke(this.server, 'shutdown');
    Ember.run(this.application, 'destroy');
  }
});

test('visiting `anime.show` with an id redirects to the slugged route', function(assert) {
  assert.expect(1);
  const data = {
    type: 'anime',
    id: '1',
    attributes: {
      slug: 'steins-gate'
    }
  };
  this.server.get('/anime/1', () => [200, {}, JSON.stringify({ data })]);
  this.server.get('/anime', () => [200, {}, JSON.stringify({ data: [data] })]);

  visit('/anime/1');
  andThen(() => assert.equal(currentURL(), '/anime/steins-gate'));
});
