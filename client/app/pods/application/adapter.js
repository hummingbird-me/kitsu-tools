import DS from 'ember-data';
import DataAdapaterMixin from 'ember-simple-auth/mixins/data-adapter-mixin';

const { JSONAPIAdapter } = DS;

export default JSONAPIAdapter.extend(DataAdapaterMixin, {
  authorizer: 'authorizer:application'
});
