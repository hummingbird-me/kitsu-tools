import { moduleFor, test } from 'ember-qunit';

moduleFor('route:sign-in', 'Unit | Route | sign in', {
  // Specify the other units that are required for this test.
  needs: ['service:metrics']
});

test('it exists', function(assert) {
  const route = this.subject();
  assert.ok(route);
});
