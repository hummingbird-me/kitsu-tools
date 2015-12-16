import Ember from 'ember';
import DataRouteErrorMixin from 'client/mixins/data-route-error';
import CanonicalUrlRedirect from 'client/mixins/canonical-url-redirect';

const {
  Route,
  get
} = Ember;

export default Route.extend(DataRouteErrorMixin, CanonicalUrlRedirect, {
  model(params) {
    const { name } = params;
    if (name.match(/\D+/)) {
      return get(this, 'store').query('user', { filter: { name } })
        .then((records) => get(records, 'firstObject'));
    } else {
      return get(this, 'store').findRecord('user', name);
    }
  }
});
