import {
  moduleForModel,
  test
} from 'ember-qunit';

moduleForModel('user-info', 'UserInfo', {
  // Specify the other units that are required for this test.
  needs: ['model:favorite', 'model:user', 'model:media']
});

test('it exists', function() {
  var model = this.subject();
  // var store = this.store();
  ok(!!model);
});
