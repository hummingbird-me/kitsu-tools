import { moduleFor, test } from 'ember-qunit';

moduleFor('route:users/library', 'Unit | Route | users/library', {
  // Specify the other units that are required for this test.
  needs: ['service:metrics']
});

test('_getNextStatuses', function(assert) {
  assert.expect(2);
  const route = this.subject();
  let result = route._getNextStatuses(1);
  assert.equal(result, '2,3,4,5');
  result = route._getNextStatuses(3);
  assert.equal(result, '1,2,4,5');
});
