import { moduleForModel, test } from 'ember-qunit';

moduleForModel('library-entry', 'Unit | Model | library-entry', {
  // Specify the other units that are required for this test.
  needs: ['model:media', 'model:user']
});

test('it works', function(assert) {
  // this.subject aliases the createRecord method on the model
  const entry = this.subject();
  assert.ok(entry);
});
