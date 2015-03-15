import {
  repeat
} from 'frontend/helpers/repeat';

module('RepeatHelper');

test('it works', function() {
  expect(1);
  var times = null;

  repeat(5, { fn: function() { times += 1; } });
  equal(times, 5);
});
