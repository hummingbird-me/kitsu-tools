import { moduleFor, test } from 'ember-qunit';

moduleFor('controller:anime/show', 'Unit | Controller | anime/show', {
  // Specify the other units that are required for this test.
  // needs: ['controller:foo']
  needs: ['service:metrics']
});

// Replace this with your real tests.
test('it exists', function(assert) {
  const controller = this.subject();
  assert.ok(controller);
});
