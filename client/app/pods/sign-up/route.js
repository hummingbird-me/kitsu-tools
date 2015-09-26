import Ember from 'ember';
import { RoutableComponentRouteMixin } from 'client/mixins/routable-component';

const { Route } = Ember;

export default Route.extend(RoutableComponentRouteMixin, {
  titleToken: 'Sign Up'
});
