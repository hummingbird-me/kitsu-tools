import {
  moduleForModel,
  test
} from 'ember-qunit';

moduleForModel('review', 'Review', {
  // Specify the other units that are required for this test.
  needs: ['model:user', 'model:anime', 'model:library-entry']
});

test('it exists', function() {
  var model = this.subject();
  // var store = this.store();
  ok(!!model);
});
