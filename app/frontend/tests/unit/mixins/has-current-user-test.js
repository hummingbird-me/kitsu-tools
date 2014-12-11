import Ember from 'ember';
import HasCurrentUserMixin from 'frontend/mixins/has-current-user';

module('HasCurrentUserMixin');

// Replace this with your real tests.
test('it works', function() {
  var HasCurrentUserObject = Ember.Object.extend(HasCurrentUserMixin);
  var subject = HasCurrentUserObject.create();
  ok(subject);
});
