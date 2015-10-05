import { moduleForModel, test } from 'ember-qunit';

moduleForModel('user', 'Unit | Model | user', {
  // Specify the other units that are required for this test.
  // needs: []
});

test('it works', function(assert) {
  // this.subject aliases the createRecord method on the model
  const user = this.subject();
  assert.ok(user);
});
