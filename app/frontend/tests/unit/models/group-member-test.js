import {
  moduleForModel,
  test
} from 'ember-qunit';

moduleForModel('group-member', 'GroupMember', {
  // Specify the other units that are required for this test.
  needs: ['model:group', 'model:user']
});

test('it exists', function() {
  var model = this.subject();
  // var store = this.store();
  ok(!!model);
});
