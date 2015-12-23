import { moduleFor, test } from 'ember-qunit';

moduleFor('controller:users/library', 'Unit | Controller | users/library', {
  // Specify the other units that are required for this test.
  needs: ['service:metrics']
});

// Replace this with your real tests.
test('it exists', function(assert) {
  const controller = this.subject();
  assert.ok(controller);
});
