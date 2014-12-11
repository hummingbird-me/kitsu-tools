import {
  moduleForModel,
  test
} from 'ember-qunit';

moduleForModel('video', 'Video', {
  // Specify the other units that are required for this test.
  needs: ['model:anime', 'model:episode']
});

test('it exists', function() {
  var model = this.subject();
  // var store = this.store();
  ok(!!model);
});
