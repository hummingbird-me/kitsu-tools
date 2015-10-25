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
  metrics: service(),

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
    get(this, 'currentSession').clean();
    this.transitionTo('dashboard');
  },

  _getCurrentUser() {
    if (!Ember.testing) {
      return get(this, 'currentSession').authorizeRequest('/users/me')
        .then((response) => {
          const data = get(this, 'store').normalize('user', response.data);
          const user = get(this, 'store').push(data);
          const userId = get(user, 'id');
          set(this, 'currentSession.userId', userId);

          // identify with analytics
          get(this, 'metrics').identify({ distinctId: userId });
        })
        .catch(() => get(this, 'currentSession').invalidate());
    }
  },

  actions: {
    invalidateSession() {
      get(this, 'currentSession').invalidate();
    }
  }
});
