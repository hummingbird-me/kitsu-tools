import JSONAPIAdapter from 'ember-data/adapters/json-api';
import DataAdapaterMixin from 'ember-simple-auth/mixins/data-adapter-mixin';

export default JSONAPIAdapter.extend(DataAdapaterMixin, {
  authorizer: 'authorizer:application',
  namespace: '/api/edge',
  coalesceFindRequests: true
});
