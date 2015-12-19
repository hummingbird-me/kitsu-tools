import { moduleForModel, test } from 'ember-qunit';

moduleForModel('media', 'Unit | Model | media', {
  // Specify the other units that are required for this test.
  // needs: []
});

test('it works', function(assert) {
  // this.subject aliases the createRecord method on the model
  const media = this.subject();
  assert.ok(media);
});
