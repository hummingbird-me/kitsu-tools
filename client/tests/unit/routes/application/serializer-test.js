import { moduleFor, test } from 'ember-qunit';
import Ember from 'ember';
import Model from 'ember-data/model';
import attr from 'ember-data/attr';
import setupStore from 'client/tests/helpers/setup-store';

const { run } = Ember;

moduleFor('serializer:application', 'Unit | Serializer | application', {
  // Specify the other units that are required for this test.
  // needs: ['serializer:application'],
  beforeEach() {
    this.store = setupStore({
      user: Model.extend({
        name: attr('string'),
        email: attr('string'),
        password: attr('string'),
        something: attr('string')
      })
    });
  },

  afterEach() {
    run(this.store, 'destroy');
  }
});

test('it only serializes changed attributes', function(assert) {
  assert.expect(1);
  let record;
  run(() => {
    record = this.store.createRecord('user', {
      name: 'Holo',
      email: 'spice@wolf.market'
    });
  });
  const serializedRecord = record.serialize();
  const data = {
    data: {
      type: 'users',
      attributes: {
        name: 'Holo',
        email: 'spice@wolf.market'
      }
    }
  };
  assert.deepEqual(serializedRecord, data);
});
