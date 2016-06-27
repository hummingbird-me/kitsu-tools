import { moduleFor, test } from 'ember-qunit';

moduleFor('route:anime/index', 'Unit | Route | anime/index', {
  needs: ['service:metrics']
});

test('serializeQueryParam', function(assert) {
  const route = this.subject();
  let result = route.serializeQueryParam([20, 50], null, 'array');
  assert.equal(result, '20..50');
  result = route.serializeQueryParam(['a', 'b', '', 'c'], null, 'array');
  assert.equal(result, 'a,b,c');
  result = route.serializeQueryParam('20..50', null, 'array');
  assert.equal(result, '20..50');
});

test('deserializeQueryParam', function(assert) {
  const route = this.subject();
  let result = route.deserializeQueryParam('20..50', null, 'array');
  assert.deepEqual(result, [20, 50]);
  result = route.deserializeQueryParam('20.5..30', null, 'array');
  assert.deepEqual(result, [20.5, 30]);
  result = route.deserializeQueryParam('a,b,c', null, 'array');
  assert.deepEqual(result, ['a', 'b', 'c']);
  result = route.deserializeQueryParam('default', null, 'string');
  assert.equal(result, 'default');
});
