import {
  moduleFor,
  test
} from 'ember-qunit';

moduleFor('controller:reviews/index', 'ReviewsIndexController', {
  // Specify the other units that are required for this test.
  needs: ['controller:anime']
});

// Replace this with your real tests.
test('it exists', function() {
  var controller = this.subject();
  ok(controller);
});
