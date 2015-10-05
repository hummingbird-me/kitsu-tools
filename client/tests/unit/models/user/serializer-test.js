import { moduleForModel, test } from 'ember-qunit';
import Ember from 'ember';

const { run, set } = Ember;

moduleForModel('user', 'Unit | Serializer | user', {
  // Specify the other units that are required for this test.
  needs: ['serializer:user']
});

test('it only serializes changed attributes', function(assert) {
  assert.expect(1);
  
  const record = this.subject();
  run(() => {
    set(record, 'name', 'Holo');
    set(record, 'email', 'spice@wolf.market');
    set(record, 'password', undefined);
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
