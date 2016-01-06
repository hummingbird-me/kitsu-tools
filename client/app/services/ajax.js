import Ember from 'ember';
import AjaxService from 'ember-ajax/services/ajax';
import getApiHost from 'client/utils/get-api-host';

const {
  computed,
  get,
  inject: { service }
} = Ember;

export default AjaxService.extend({
  session: service(),

  host: computed({
    get() {
      return getApiHost();
    }
  }),

  headers: computed('session.isAuthenticated', {
    get() {
      const headers = {};
      get(this, 'session').authorize('authorizer:application', (headerName, headerValue) => {
        headers[headerName] = headerValue;
      });
      return headers;
    }
  }),

  options(url, options) {
    const hash = this._super(...arguments);
    hash.url = options && options.includesHost ? url : hash.url;
    return hash;
  }
});
