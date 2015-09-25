import Ember from 'ember';
import config from 'client/config/environment';

const { Route, on } = Ember;

export default Route.extend({
  title(tokens) {
    const base = 'Hummingbird';
    const hasTokens = tokens && tokens.length;
    return hasTokens ? `${tokens.reverse().join(' | ')} | ${base}` : base;
  },

  setupAnalytics: on('activate', function() {
    if (config.environment === 'production') {
      window.analytics.load(config.segmentToken);
    }
  })
});
