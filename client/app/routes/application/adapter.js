import Ember from 'ember';
import JSONAPIAdapter from 'ember-data/adapters/json-api';
import DataAdapaterMixin from 'ember-simple-auth/mixins/data-adapter-mixin';
import getApiHost from 'client/utils/get-api-host';

const {
  computed
} = Ember;

export default JSONAPIAdapter.extend(DataAdapaterMixin, {
  authorizer: 'authorizer:application',
  coalesceFindRequests: true,

  host: computed({
    get() {
      return getApiHost();
    }
  })
});
