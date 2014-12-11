import {
  moduleForModel,
  test
} from 'ember-qunit';

moduleForModel('episode', 'Episode', {
  // Specify the other units that are required for this test.
  needs: ['model:anime', 'model:library-entry', 'model:video']
});

test('it exists', function() {
  var model = this.subject();
  // var store = this.store();
  ok(!!model);
});
