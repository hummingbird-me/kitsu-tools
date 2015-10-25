import Ember from 'ember';
import { RoutableComponentRouteMixin } from 'client/mixins/routable-component';
import AuthenticatedRouteMixin from 'ember-simple-auth/mixins/authenticated-route-mixin';

const {
  Route,
  get,
  inject: { service }
} = Ember;

export default Route.extend(RoutableComponentRouteMixin, AuthenticatedRouteMixin, {
  currentSession: service(),

  // Redirect the user to the dashboard if they have already been thru the
  // onboarding process.
  redirect() {
    if (get(this, 'currentSession.account.onboarded')) {
      this.transitionTo('dashboard');
    } else {
      this.transitionTo('onboarding.start');
    }
  }
});
