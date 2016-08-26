import Route from 'ember-route';
import get from 'ember-metal/get';
import service from 'ember-service/inject';
import AuthenticatedRouteMixin from 'ember-simple-auth/mixins/authenticated-route-mixin';

export default Route.extend(AuthenticatedRouteMixin, {
  session: service(),

  /**
   * Redirect to `dashboard` if the user has already been onboarded.
   */
  redirect() {
    if (get(this, 'session.account.onboarded')) {
      this.transitionTo('dashboard');
    } else {
      this.transitionTo('onboarding.start');
    }
  }
});
