import Ember from 'ember';
import ApplicationRouteMixin from 'ember-simple-auth/mixins/application-route-mixin';

const {
  Route,
  get,
  set,
  inject: { service }
} = Ember;

export default Route.extend(ApplicationRouteMixin, {
  currentSession: service(),

  // If you are visiting the site while authenticated, lets grab your data
  beforeModel() {
    const session = get(this, 'currentSession');
    if (get(session, 'isAuthenticated')) {
      // we return the promise here, as it will pause the transition until
      // we have received the data
      return this._getCurrentUser();
    }
  },

  title(tokens) {
    const base = 'Hummingbird';
    const hasTokens = tokens && tokens.length;
    return hasTokens ? `${tokens.reverse().join(' | ')} | ${base}` : base;
  },

  // This method is fired by ESA when authentication is successful
  sessionAuthenticated() {
    this._getCurrentUser();
    this._super(...arguments);
  },

  // By default, ESA reloads the browser to `baseURL`
  // we don't want that, so just redirect to dashboard
  sessionInvalidated() {
    this.transitionTo('dashboard');
  },

  _getCurrentUser() {
    // don't run in test environment
    if (!Ember.testing) {
      // @Cleanup: This stores an undefined record under users
      return get(this, 'store').findRecord('user', 'me').then((user) => {
        const userId = get(user, 'id');
        set(this, 'currentSession.userId', userId);
      }).catch(() => {
        // If we error (404/Something is broken), then invalidate the session
        get(this, 'currentSession').invalidate();
      });
    }
  }
});
