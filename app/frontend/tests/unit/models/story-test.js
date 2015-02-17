import {
  moduleForModel,
  test
} from 'ember-qunit';

moduleForModel('story', 'Story', {
  // Specify the other units that are required for this test.
  needs: ['model:group', 'model:group-member',
    'model:user', 'model:media', 'model:substory']
});

test('it exists', function() {
  var model = this.subject();
  // var store = this.store();
  ok(!!model);
});
