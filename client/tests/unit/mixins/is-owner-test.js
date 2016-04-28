import EmberObject from 'ember-object';
import get from 'ember-metal/get';
import IsOwnerMixin from '../../../mixins/is-owner';
import { module, test } from 'qunit';

module('Unit | Mixin | is owner', {
  beforeEach() {
    this.currentSession = EmberObject.create({
      userId: 20,
      isCurrentUser(user) {
        return get(this, 'userId') === get(user, 'id');
      }
    });
    this.user = EmberObject.create({ id: 20 });
  }
});

test('it works', function(assert) {
  const IsOwnerObject = EmberObject.extend(IsOwnerMixin, {
    currentSession: this.currentSession,
    user: this.user
  });
  const subject = IsOwnerObject.create();
  assert.ok(get(subject, 'isOwner'));
});
