import Ember from 'ember';
import config from './config/environment';

const {
  on,
  get,
  getWithDefault,
  run,
  inject: { service }
} = Ember;

const Router = Ember.Router.extend({
  location: config.locationType,
  metrics: service(),

  _notifyGoogleAnalytics: on('didTransition', function() {
    run.scheduleOnce('afterRender', this, () => {
      // @Temporary: Next version of `ember-metrics` will allow disabling it.
      if (config.environment === 'production') {
        const page = get(this, 'url');
        const title = getWithDefault(this, 'currentRouteName', 'unknown');
        get(this, 'metrics').trackPage({ page, title });
      }
    });
  })
});

Router.map(function() {
  this.route('dashboard', { path: '/' });
  this.route('dashboard/redirect', { path: '/dashboard' });

  // authentication
  this.route('sign-up');
  this.route('sign-in');
});

export default Router;
