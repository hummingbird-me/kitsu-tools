import { moduleFor, test } from 'ember-qunit';

moduleFor('route:application', 'Unit | Route | application', {
  // Specify the other units that are required for this test.
  needs: ['service:session', 'service:metrics']
});

test('it exists', function(assert) {
  const route = this.subject();
  assert.ok(route);
});

test('title works', function(assert) {
  assert.expect(2);
  const route = this.subject();
  assert.equal(route.title(['One', 'Two']), 'Two | One | Hummingbird');
  assert.equal(route.title(), 'Hummingbird');
});
