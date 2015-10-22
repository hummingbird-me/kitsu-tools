import Ember from 'ember';
import { request } from 'ic-ajax';
import getApiHost from 'client/utils/get-api-host';

const {
  Service,
  get,
  set,
  isPresent,
  computed,
  inject: { service },
  RSVP: { Promise }
} = Ember;

export default Service.extend({
  session: service(),
  store: service(),
  userId: null,

  isAuthenticated: computed.alias('session.isAuthenticated'),

  account: computed('userId', function() {
    const userId = get(this, 'userId');
    if (isPresent(userId)) {
      return get(this, 'store').peekRecord('user', userId);
    }
  }),

  authenticateWithOAuth2(identification, password) {
    return get(this, 'session').authenticate('authenticator:oauth2', identification, password);
  },

  authorizeRequest(endpoint) {
    return new Promise((resolve, reject) => {
      get(this, 'session').authorize('authorizer:application', (headerName, headerValue) => {
        const host = getApiHost();
        const headers = {};
        headers[headerName] = headerValue;
        request(`${host}${endpoint}`, { headers })
          .then(resolve, reject);
      });
    });
  },

  invalidate() {
    return get(this, 'session').invalidate();
  },

  clean() {
    set(this, 'userId', null);
  }
});
