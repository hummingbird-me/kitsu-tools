import Ember from 'ember';
import ModelCurrentUserMixin from 'frontend/mixins/model-current-user';

module('ModelCurrentUserMixin');

// Replace this with your real tests.
test('it works', function() {
  var ModelCurrentUserObject = Ember.Object.extend(ModelCurrentUserMixin);
  var subject = ModelCurrentUserObject.create();
  ok(subject);
});
