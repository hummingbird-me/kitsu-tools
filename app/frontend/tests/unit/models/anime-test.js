import {
  moduleForModel,
  test
} from 'ember-qunit';

moduleForModel('anime', 'Anime', {
  // Specify the other units that are required for this test.
  needs: ['model:library-entry']
});

test('it exists', function() {
  var model = this.subject();
  // var store = this.store();
  ok(!!model);
});
