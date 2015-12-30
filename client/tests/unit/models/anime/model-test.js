import { moduleForModel, test } from 'ember-qunit';

moduleForModel('anime', 'Unit | Model | anime', {
  // Specify the other units that are required for this test.
  needs: ['model:genre']
});

test('it works', function(assert) {
  // this.subject aliases the createRecord method on the model
  const anime = this.subject();
  assert.ok(anime);
});
