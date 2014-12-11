import {
  formatTime
} from 'frontend/helpers/format-time';

module('FormatTimeHelper');

test('it works', function() {
  var result = formatTime(new Date(1994, 1, 18), "YYYY-MM-DD");
  equal(result, '1994-02-18');
});
