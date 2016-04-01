import EmberObject from 'ember-object';
import get from 'ember-metal/get';
import IsViewingSelfMixin from '../../../mixins/is-viewing-self';
import { module, test } from 'qunit';

module('Unit | Mixin | is viewing self', {
  beforeEach() {
    this.currentSession = EmberObject.create({
      userId: 20,
      isCurrentUser(user) {
        return get(this, 'userId') === get(user, 'id');
      }
    });
    this.user = EmberObject.create({
      id: 20
    });
  }
});

test('it works', function(assert) {
  const IsViewingSelfObject = EmberObject.extend(IsViewingSelfMixin, {
    currentSession: this.currentSession,
    user: this.user
  });
  const subject = IsViewingSelfObject.create();
  assert.ok(get(subject, 'isViewingSelf'));
});
