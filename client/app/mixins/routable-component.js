/*
  Hack file to get routable components working. Removable when routable
  components lands in beta/release.
*/
import Ember from 'ember';

const { Mixin } = Ember;

// isGlimmerComponent is a flag for routable components
export const RoutableComponentMixin = Mixin.create({
  isGlimmerComponent: true
});

// there is currently a bug with ember-cli that they are aware of, we are
// forced to define a templateName that won't be found so it uses the component
// template instead.
export const RoutableComponentRouteMixin = Mixin.create({
  templateName: 'undefined'
});
