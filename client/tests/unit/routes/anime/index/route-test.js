import { moduleFor, test } from 'ember-qunit';

moduleFor('route:anime/index', 'Unit | Route | anime/index', {
  // Specify the other units that are required for this test.
  needs: ['service:metrics']
});

test('it exists', function(assert) {
  const route = this.subject();
  assert.ok(route);
});
