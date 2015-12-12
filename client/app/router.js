import Ember from 'ember';
import config from './config/environment';

const {
  getWithDefault,
  run,
  inject: { service }
} = Ember;

const Router = Ember.Router.extend({
  location: config.locationType,
  metrics: service(),

  didTransition() {
    this._super(...arguments);
    run.scheduleOnce('afterRender', this, () => {
      const page = Ember.get(this, 'url');
      const title = getWithDefault(this, 'currentRouteName', 'unknown');
      Ember.get(this, 'metrics').trackPage({ page, title });
    });
  }
});

Router.map(function() {
  this.route('dashboard', { path: '/' });
  this.route('dashboard/redirect', { path: '/dashboard' });

  this.route('anime', function() {
    this.route('show', { path: '/:slug' });
  });

  this.route('users', { path: '/users/:name' }, function() {
    this.route('library');
    this.route('reviews');
    this.route('lists');
  });

  this.route('onboarding', function() {
    this.route('start');
    // TODO: Rest of onboarding flow
  });

  // authentication
  this.route('sign-up');
  this.route('sign-in');

  // @Note: These must remain at the bottom of the Router map
  this.route('server-error', { path: '/500' });
  this.route('not-found', { path: '/*path' });
});

export default Router;
