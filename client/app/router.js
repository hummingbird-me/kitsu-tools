import Ember from 'ember';
import config from './config/environment';

const Router = Ember.Router.extend({
  location: config.locationType
});

Router.reopen({
  // https://segment.com/docs/libraries/analytics.js/#page
  _trackPageView: Ember.on('didTransition', function() {
    if (config.environment === 'production') {
      window.analytics.page();
    }
  })
});

Router.map(function() {
  this.route('landing', { path: '/' });
  this.route('dashboard');

  // authentication
  this.route('sign-up');
});

export default Router;
