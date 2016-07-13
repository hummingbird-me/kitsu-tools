import Service from 'ember-service';
import get from 'ember-metal/get';
import set from 'ember-metal/set';
import { alias } from 'ember-computed';
import service from 'ember-service/inject';

export default Service.extend({
  account: undefined,
  ajax: service(),
  session: service(),
  store: service(),
  isAuthenticated: alias('session.isAuthenticated'),

  authenticateWithOAuth2(identification, password) {
    return get(this, 'session')
      .authenticate('authenticator:oauth2', identification, password);
  },

  invalidate() {
    return get(this, 'session').invalidate();
  },

  isCurrentUser(user) {
    const isAuthenticated = get(this, 'isAuthenticated');
    const userId = get(this, 'account.id');
    return isAuthenticated && userId === get(user, 'id');
  },

  getCurrentUser() {
    return get(this, 'ajax').request('/users?filter[self]=true')
      .then((response) => {
        const [data] = response.data;
        const normalizedData = get(this, 'store').normalize('user', data);
        const user = get(this, 'store').push(normalizedData);
        set(this, 'account', user);
        return user;
      });
  }
});
