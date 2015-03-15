import Ember from 'ember';
import ModelTruncatedDetailsMixin from 'frontend/mixins/model-truncated-details';

module('ModelTruncatedDetailsMixin');

// Replace this with your real tests.
test('it works', function() {
  var ModelTruncatedDetailsObject = Ember.Object.extend(ModelTruncatedDetailsMixin);
  var subject = ModelTruncatedDetailsObject.create();
  ok(subject);
});
