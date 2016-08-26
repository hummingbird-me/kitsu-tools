import Route from 'ember-route';
import get from 'ember-metal/get';
import service from 'ember-service/inject';
import ApplicationRouteMixin from 'ember-simple-auth/mixins/application-route-mixin';

export default Route.extend(ApplicationRouteMixin, {
  i18n: service(),
  metrics: service(),
  session: service(),

  // If the user is authenticated on first load, grab the users data
  beforeModel() {
    const session = get(this, 'session');
    if (get(session, 'isAuthenticated')) {
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

  _getCurrentUser() {
    const isAuthenticated = get(this, 'session.isAuthenticated');
    if (isAuthenticated === true) {
      return get(this, 'session').getCurrentUser()
        .then((user) => get(this, 'metrics').identify({ distinctId: get(user, 'id') }))
        .catch(() => get(this, 'session').invalidate());
    }
  }
});
