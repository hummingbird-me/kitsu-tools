import Ember from 'ember';
import HasCoverUploadMixin from 'frontend/mixins/has-cover-upload';

module('HasCoverUploadMixin');

// Replace this with your real tests.
test('it works', function() {
  var HasCoverUploadObject = Ember.Object.extend(HasCoverUploadMixin);
  var subject = HasCoverUploadObject.create();
  ok(subject);
});
