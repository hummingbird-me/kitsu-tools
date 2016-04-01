import { moduleFor, test } from 'ember-qunit';
import run from 'ember-runloop';
import Model from 'ember-data/model';
import attr from 'ember-data/attr';
import setupStore from 'client/tests/helpers/setup-store';

moduleFor('service:current-session', 'Unit | Service | current session', {
  beforeEach() {
    this.store = setupStore({
      user: Model.extend({
        name: attr('string')
      })
    });
  },

  afterEach() {
    run(this.store, 'destroy');
  }
});

// Replace this with your real tests.
test('#account peeks userId and returns correct data', function(assert) {
  const service = this.subject({ store: this.store, userId: 1 });
  run(() => {
    this.user = this.store.push({
      data: {
        type: 'user',
        id: '1',
        attributes: {
          name: 'Holo'
        }
      }
    });
  });

  assert.equal(service.get('account'), this.user);
  assert.equal(service.get('account.name'), 'Holo');
});

test('#account returns null if userId doesn\'t exist', function(assert) {
  const service = this.subject();
  assert.equal(service.get('account'), null);
});
