import Route from 'ember-route';
import get from 'ember-metal/get';
import set from 'ember-metal/set';
import service from 'ember-service/inject';
import ApplicationRouteMixin from 'ember-simple-auth/mixins/application-route-mixin';

export default Route.extend(ApplicationRouteMixin, {
  currentSession: service(),
  i18n: service(),
  metrics: service(),
  ajax: service(),

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
    // If the route hasn't defined a `titleToken` then try to grab the route
    // name from the `titles` table in translations.
    const hasTokens = tokens && tokens.length > 0;
    if (hasTokens === false) {
      let title = get(this, 'i18n')
        .t(`titles.${get(this, 'router.currentRouteName')}`) || undefined;
      if (title && title.toString().includes('Missing translation')) {
        title = undefined;
      }
      tokens = title ? [title] : undefined;
    }
    return tokens ? `${tokens.reverse().join(' | ')} | ${base}` : base;
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
    return get(this, 'ajax').request('/users?filter[self]=true')
      .then((response) => {
        const [data] = response.data;
        const normalizedData = get(this, 'store').normalize('user', data);
        const user = get(this, 'store').push(normalizedData);
        const userId = get(user, 'id');
        set(this, 'currentSession.userId', userId);

        // identify with analytics
        get(this, 'metrics').identify({ distinctId: userId });
      })
      .catch(() => get(this, 'currentSession').invalidate());
  }
});
