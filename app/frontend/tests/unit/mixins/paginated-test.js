import Ember from 'ember';
import PaginatedMixin from 'frontend/mixins/paginated';

module('PaginatedMixin');

// Replace this with your real tests.
test('it works', function() {
  var PaginatedObject = Ember.Object.extend(PaginatedMixin);
  var subject = PaginatedObject.create();
  ok(subject);
});
