import Ember from 'ember';
import { module, test } from 'qunit';
import startApp from 'client/tests/helpers/start-app';
import sinon from 'sinon';
import Pretender from 'pretender';

module('Acceptance | anime', {
  beforeEach() {
    this.application = startApp();
    this.sandbox = sinon.sandbox.create();
    this.server = new Pretender();
    this.store = this.application.__container__.lookup('service:store');
  },

  afterEach() {
    Ember.run(this.application, 'destroy');
    this.sandbox.restore();
  }
});

test('visiting /anime/steins-gate should lookup the model', function(assert) {
  assert.expect(3);

  const stub = this.sandbox.stub(this.store, 'findRecord', () => true);
  visit('/anime/steins-gate');

  andThen(() => {
    assert.equal(currentURL(), '/anime/steins-gate');
    assert.equal(currentRouteName(), 'anime.show');
    assert.ok(stub.calledWith('anime', 'steins-gate'), 'called findRecord correctly');
  });
});

test('visiting /anime/steins-gate should retrieve and show data', function(assert) {
  assert.expect(1);

  this.server.get('/anime/steins-gate', () => {
    const data = JSON.stringify({
      data: {
        type: 'anime',
        id: 1,
        attributes: {
          slug: 'steins-gate'
        }
      }
    });
    return [200, {}, data];
  });

  visit('/anime/steins-gate');
  andThen(() => {
    assert.equal(this.store.peekRecord('anime', 1).get('slug'), 'steins-gate');
  });

  // TODO: assert that the data is shown.
});
