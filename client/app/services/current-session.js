import Service from 'ember-service';
import get from 'ember-metal/get';
import set from 'ember-metal/set';
import { isPresent } from 'ember-utils';
import computed, { alias } from 'ember-computed';
import service from 'ember-service/inject';

export default Service.extend({
  session: service(),
  store: service(),
  userId: undefined,

  isAuthenticated: alias('session.isAuthenticated'),

  account: computed('userId', {
    get() {
      const userId = get(this, 'userId');
      return isPresent(userId) ? get(this, 'store').peekRecord('user', userId) : undefined;
    }
  }),

  authenticateWithOAuth2(identification, password) {
    return get(this, 'session').authenticate('authenticator:oauth2', identification, password);
  },

  invalidate() {
    return get(this, 'session').invalidate();
  },

  clean() {
    set(this, 'userId', undefined);
  },

  isCurrentUser(user) {
    const isAuthenticated = get(this, 'isAuthenticated');
    const userId = get(this, 'userId');
    return isAuthenticated && userId === get(user, 'id');
  }
});
