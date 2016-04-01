import computed from 'ember-computed';
import JSONAPIAdapter from 'ember-data/adapters/json-api';
import DataAdapaterMixin from 'ember-simple-auth/mixins/data-adapter-mixin';
import getApiHost from 'client/utils/get-api-host';

export default JSONAPIAdapter.extend(DataAdapaterMixin, {
  authorizer: 'authorizer:application',
  coalesceFindRequests: true,

  host: computed({
    get() {
      return getApiHost();
    }
  })
});
