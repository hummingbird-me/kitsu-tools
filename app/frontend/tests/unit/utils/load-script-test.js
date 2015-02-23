import loadScript from 'frontend/utils/load-script';

module('loadScript');

// Replace this with your real tests.
test('it works', function() {
  expect(1);
  
  loadScript("https://www.example.com/app.js");
  equal(find('script[src="https://www.example.com/app.js"]', document.body).length, 1);
});
