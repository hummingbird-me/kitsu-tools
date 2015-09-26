import Ember from 'ember';
import { RoutableComponentRouteMixin, RoutableComponentMixin } from 'client/mixins/routable-component';
import { module, test } from 'qunit';

module('Unit | Mixin | routable component');

test('isGlimmerComponent is true', function(assert) {
  let component = Ember.Object.extend(RoutableComponentMixin).create();
  assert.ok(component.isGlimmerComponent);
});

test('templateName is undefined', function(assert) {
  let route = Ember.Object.extend(RoutableComponentRouteMixin).create();
  assert.equal(route.templateName, 'undefined');
});
