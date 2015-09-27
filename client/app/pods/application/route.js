import Ember from 'ember';
import config from 'client/config/environment';
import ApplicationRouteMixin from 'ember-simple-auth/mixins/application-route-mixin';

const { Route, on } = Ember;

export default Route.extend(ApplicationRouteMixin, {
  title(tokens) {
    const base = 'Hummingbird';
    const hasTokens = tokens && tokens.length;
    return hasTokens ? `${tokens.reverse().join(' | ')} | ${base}` : base;
  },

  _setupAnalytics: on('activate', function() {
    if (config.environment === 'production') {
      window.analytics.load(config.segmentToken);
    }
  })
});
