import PreloadStore from 'frontend/utils/preload-store';

module('preloadStore');

test('#get', function() {
  expect(3);

  window.genericPreload = {
    "foo": "bar"
  };

  equal(PreloadStore.get('foo'), 'bar');
  equal(PreloadStore.get('baz'), null);
  equal(PreloadStore.get('baz', function() { return 'foobar'; }), 'foobar');

  delete window['genericPreload'];
});

test('#pop', function() {
  expect(4);
  
  window.genericPreload = {
    "foo": "bar"
  };

  equal(PreloadStore.pop('foo'), 'bar');
  equal(PreloadStore.pop('foo'), null);
  equal(PreloadStore.get('baz', function() { return 'foobar'; }), 'foobar');
  equal(PreloadStore.pop('baz'), null);

  delete window['genericPreload'];
});
