import DS from 'ember-data';
import DataAdapaterMixin from 'ember-simple-auth/mixins/data-adapter-mixin';
import config from 'client/config/environment';

const { JSONAPIAdapter } = DS;

export default JSONAPIAdapter.extend(DataAdapaterMixin, {
  host: config.host,
  authorizer: 'authorizer:application'
});
