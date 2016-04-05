import { isEmpty } from 'client/helpers/is-empty';
import { module, test } from 'qunit';

module('Unit | Helper | is empty');

test('it works', function(assert) {
  assert.expect(6);
  assert.ok(isEmpty(['']));
  assert.ok(isEmpty([undefined]));
  assert.ok(isEmpty([null]));
  assert.ok(isEmpty([]));
  assert.notOk(isEmpty([42]));
  assert.notOk(isEmpty(['Hello, World!']));
});
