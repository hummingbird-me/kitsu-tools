import Ember from 'ember';
import config from './config/environment';

var Router = Ember.Router.extend({
  location: config.locationType
});

Router.reopen({
  // https://segment.com/docs/libraries/analytics.js/#page
  trackPageView: Ember.on('didTransition', function() {
    if (config.environment === 'production') {
      window.analytics.page();
    }
  })
});

Router.map(function() {
  this.route('landing', { path: '/' });
  this.route('sign-up');
});

export default Router;
