import Ember from 'ember';
import { RoutableComponentRouteMixin } from 'client/mixins/routable-component';
import UnauthenticatedRouteMixin from 'ember-simple-auth/mixins/unauthenticated-route-mixin';

export default Ember.Route.extend(RoutableComponentRouteMixin, UnauthenticatedRouteMixin, {
  titleToken: 'Sign In'
});
