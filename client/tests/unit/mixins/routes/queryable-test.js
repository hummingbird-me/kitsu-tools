import EObject from 'ember-object';
import QueryableMixin from 'client/mixins/routes/queryable';
import { module, test } from 'qunit';

module('Unit | Mixin | Routes | queryable');

test('serializeQueryParam', function(assert) {
  const QueryableObject = EObject.extend(QueryableMixin);
  const subject = QueryableObject.create();
  let result = subject.serializeQueryParam([20, 50], null, 'array');
  assert.equal(result, '20..50');
  result = subject.serializeQueryParam(['a', 'b', '', 'c'], null, 'array');
  assert.equal(result, 'a,b,c');
  result = subject.serializeQueryParam('20..50', null, 'array');
  assert.equal(result, '20..50');
});

test('deserializeQueryParam', function(assert) {
  const QueryableObject = EObject.extend(QueryableMixin);
  const subject = QueryableObject.create();
  let result = subject.deserializeQueryParam('20..50', null, 'array');
  assert.deepEqual(result, [20, 50]);
  result = subject.deserializeQueryParam('20.5..30', null, 'array');
  assert.deepEqual(result, [20.5, 30]);
  result = subject.deserializeQueryParam('a,b,c', null, 'array');
  assert.deepEqual(result, ['a', 'b', 'c']);
});
