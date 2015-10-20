import Ember from 'ember';
import DS from 'ember-data';
import DataAdapaterMixin from 'ember-simple-auth/mixins/data-adapter-mixin';
import getApiHost from 'client/utils/get-api-host';

const { computed } = Ember;
const { JSONAPIAdapter } = DS;

export default JSONAPIAdapter.extend(DataAdapaterMixin, {
  authorizer: 'authorizer:application',

  host: computed(function() {
    return getApiHost();
  })
});
