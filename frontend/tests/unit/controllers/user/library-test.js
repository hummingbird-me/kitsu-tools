import {
  moduleFor,
  test
} from 'ember-qunit';

moduleFor('controller:user/library', 'UserLibraryController', {
  // Specify the other units that are required for this test.
  needs: ['controller:user']
});

// Replace this with your real tests.
test('it exists', function() {
  var controller = this.subject();
  ok(controller);
});
