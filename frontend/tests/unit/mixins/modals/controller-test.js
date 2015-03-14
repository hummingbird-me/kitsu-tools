import Ember from 'ember';
import ModalsControllerMixin from 'frontend/mixins/modals/controller';

module('ModalsControllerMixin');

// Replace this with your real tests.
test('it works', function() {
  var ModalsControllerObject = Ember.Object.extend(ModalsControllerMixin);
  var subject = ModalsControllerObject.create();
  ok(subject);
});
