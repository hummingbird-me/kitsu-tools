import wilsonScore from 'frontend/utils/wilson-score';

module('wilsonScore');

// Replace this with your real tests.
test('it works', function() {
  expect(3);
  
  equal(wilsonScore(0, 0), 0);
  equal(wilsonScore(0, 100), 0);
  ok(wilsonScore(100000, 100000) > 0.99);
});
