import { moduleFor, test } from 'ember-qunit';

moduleFor('route:application', 'Unit | Route | application', {
  needs: ['service:session', 'service:metrics']
});

test('title works', function(assert) {
  assert.expect(2);
  const route = this.subject();
  assert.equal(route.title(['One', 'Two']), 'Two | One | Hummingbird');
  assert.equal(route.title(), 'Hummingbird');
});
