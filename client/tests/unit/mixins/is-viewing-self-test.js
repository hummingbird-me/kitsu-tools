import Ember from 'ember';
import IsViewingSelfMixin from '../../../mixins/is-viewing-self';
import { module, test } from 'qunit';

module('Unit | Mixin | is viewing self', {
  beforeEach() {
    this.currentSession = Ember.Object.create({
      userId: 20,
      isCurrentUser(user) {
        return Ember.get(this, 'userId') === Ember.get(user, 'id');
      }
    });
    this.user = Ember.Object.create({
      id: 20
    });
  }
});

test('it works', function(assert) {
  const IsViewingSelfObject = Ember.Object.extend(IsViewingSelfMixin, {
    currentSession: this.currentSession,
    user: this.user
  });
  const subject = IsViewingSelfObject.create();
  assert.ok(Ember.get(subject, 'isViewingSelf'));
});
