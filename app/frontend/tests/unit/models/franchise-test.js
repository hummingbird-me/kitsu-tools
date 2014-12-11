import {
  moduleForModel,
  test
} from 'ember-qunit';

moduleForModel('franchise', 'Franchise', {
  // Specify the other units that are required for this test.
  needs: ['model:anime', 'model:library-entry']
});

test('it exists', function() {
  var model = this.subject();
  // var store = this.store();
  ok(!!model);
});
