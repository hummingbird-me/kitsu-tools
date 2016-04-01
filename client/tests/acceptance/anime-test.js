import { tryInvoke } from 'ember-utils';
import { test } from 'qunit';
import moduleForAcceptance from 'client/tests/helpers/module-for-acceptance';
import Pretender from 'pretender';

moduleForAcceptance('Acceptance | anime', {
  beforeEach() {
    this.server = new Pretender();
  },

  afterEach() {
    tryInvoke(this.server, 'shutdown');
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
