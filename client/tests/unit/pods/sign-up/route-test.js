import { moduleFor, test } from 'ember-qunit';

moduleFor('route:sign-up', 'Unit | Route | sign up', {
  // Specify the other units that are required for this test.
  needs: ['service:metrics']
});

test('it exists', function(assert) {
  const route = this.subject();
  assert.ok(route);
});
