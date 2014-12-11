import Ember from 'ember';
import ModalsVersionableMixin from 'frontend/mixins/modals/versionable';

module('ModalsVersionableMixin');

// Replace this with your real tests.
test('it works', function() {
  var ModalsVersionableObject = Ember.Object.extend(ModalsVersionableMixin);
  var subject = ModalsVersionableObject.create();
  ok(subject);
});
