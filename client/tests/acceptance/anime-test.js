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

test('visiting `anime.show` should render data', function(assert) {
  assert.expect(1);
  this.server.get('/anime/steins-gate', () => {
    const data = {
      type: 'anime',
      id: 1,
      attributes: {
        slug: 'steins-gate',
        'canonical_title': 'Steins;Gate'
      }
    };
    return [200, {}, JSON.stringify({ data })];
  });

  visit('/anime/steins-gate');
  andThen(() => {
    assert.equal(find('[data-test-selector="title"]').text(), 'Steins;Gate');
  });
});
