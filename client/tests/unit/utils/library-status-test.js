import libraryStatus from '../../../utils/library-status';
import { module, test } from 'qunit';

module('Unit | Utility | library status');

test('getHumanStatuses', function(assert) {
  assert.expect(1);
  const result = libraryStatus.getHumanStatuses();
  assert.deepEqual(result, ['Currently Watching', 'Plan to Watch', 'Completed', 'On Hold', 'Dropped']);
});

test('numberToHuman', function(assert) {
  assert.expect(1);
  const result = libraryStatus.numberToHuman(2);
  assert.equal(result, 'Plan to Watch');
});

test('enumToNumber', function(assert) {
  assert.expect(1);
  const result = libraryStatus.enumToNumber('on_hold');
  assert.equal(result, 4);
});

test('humanToEnum', function(assert) {
  assert.expect(1);
  const result = libraryStatus.humanToEnum('Plan to Watch');
  assert.equal(result, 'planned');
});

test('humanToNumber', function(assert) {
  assert.expect(1);
  const result = libraryStatus.humanToNumber('Plan to Watch');
  assert.equal(result, 2);
});

test('enumToHuman', function(assert) {
  assert.expect(1);
  const result = libraryStatus.enumToHuman('planned');
  assert.equal(result, 'Plan to Watch');
});
