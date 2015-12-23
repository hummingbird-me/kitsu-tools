import { moduleFor, test } from 'ember-qunit';

moduleFor('route:onboarding', 'Unit | Route | onboarding', {
  // Specify the other units that are required for this test.
  needs: ['service:metrics']
});

test('it exists', function(assert) {
  const route = this.subject();
  assert.ok(route);
});
