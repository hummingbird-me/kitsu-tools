import { moduleFor, test } from 'ember-qunit';

moduleFor('route:application', 'Unit | Route | application', {
  // Specify the other units that are required for this test.
  // needs: ['controller:foo']
});

test('it exists', function(assert) {
  var route = this.subject();
  assert.ok(route);
});

test('title works', function(assert) {
  assert.expect(2);
  let route = this.subject();
  assert.equal(route.title(['One', 'Two']), 'Two | One | Hummingbird');
  assert.equal(route.title(), 'Hummingbird');
});
