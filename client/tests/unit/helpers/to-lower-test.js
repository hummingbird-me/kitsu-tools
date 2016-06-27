import { toLower } from 'client/helpers/to-lower';
import { module, test } from 'qunit';

module('Unit | Helper | to lower');

test('it works with an object property', function(assert) {
  assert.expect(1);
  const obj = { hello: 'WORLD' };
  const result = toLower([obj.hello]);
  assert.equal(result, 'world');
});

test('it works with an array of strings', function(assert) {
  assert.expect(1);
  const arr = ['A', 'B', 'C'];
  const result = toLower([arr]);
  assert.deepEqual(result, ['a', 'b', 'c']);
});

test('it works with a single string', function(assert) {
  assert.expect(1);
  const result = toLower(['heLLo']);
  assert.equal(result, 'hello');
});

test('returns empty string if no arguments', function(assert) {
  assert.expect(1);
  const result = toLower([]);
  assert.equal(result, '');
});
