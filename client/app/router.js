import Router from 'ember-router';
import service from 'ember-service/inject';
import { scheduleOnce } from 'ember-runloop';
import get from 'ember-metal/get';
import config from './config/environment';

const RouterInstance = Router.extend({
  location: config.locationType,
  rootURL: config.rootURL,
  metrics: service(),

  didTransition() {
    this._super(...arguments);
    scheduleOnce('afterRender', this, () => {
      const page = get(this, 'url');
      const title = get(this, 'currentRouteName') || 'Unknown';
      get(this, 'metrics').trackPage({ page, title });
    });
  }
});

RouterInstance.map(function() {
  this.route('dashboard', { path: '/' });
  this.route('dashboard/redirect', { path: '/dashboard' });

  this.route('anime', function() {
    this.route('show', { path: '/:slug' });
  });

  this.route('drama', function() {
    this.route('show', { path: '/:slug' });
  });

  this.route('users', { path: '/users/:name' }, function() {
    this.route('library');
    this.route('reviews');
    this.route('lists');
  });

  this.route('onboarding', function() {
    this.route('start');
  });

  // Authentication
  this.route('sign-up');
  this.route('sign-in');

  // These must remain at the bottom of the RouterInstance map
  this.route('server-error', { path: '/500' });
  this.route('not-found', { path: '/*path' });
});

export default RouterInstance;
