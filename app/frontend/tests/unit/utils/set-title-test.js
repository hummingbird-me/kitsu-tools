import setTitle from 'frontend/utils/set-title';

module('setTitle');

// Replace this with your real tests.
test('it works', function() {
  expect(3);
  
  setTitle();
  equal(document.title, 'Hummingbird');
  setTitle("");
  equal(document.title, 'Hummingbird');
  setTitle("Test");
  equal(document.title, 'Test | Hummingbird');
});
