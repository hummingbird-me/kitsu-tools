import { moduleForModel, test } from 'ember-qunit';

moduleForModel('genre', 'Unit | Model | genre', {
  // Specify the other units that are required for this test.
  // needs: []
});

test('it works', function(assert) {
  // this.subject aliases the createRecord method on the model
  const genre = this.subject();
  assert.ok(genre);
});
