import libraryStatus from '../../../utils/library-status';
import { module, test } from 'qunit';

module('Unit | Utility | library status');

test('getEnumKeys', function(assert) {
  assert.expect(1);
  const result = libraryStatus.getEnumKeys();
  assert.deepEqual(result, ['current', 'planned', 'completed', 'on_hold', 'dropped']);
});

test('numberToEnum', function(assert) {
  assert.expect(1);
  const result = libraryStatus.numberToEnum(2);
  assert.equal(result, 'planned');
});

test('enumToNumber', function(assert) {
  assert.expect(1);
  const result = libraryStatus.enumToNumber('on_hold');
  assert.equal(result, 4);
});
