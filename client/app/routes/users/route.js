import Route from 'ember-route';
import get from 'ember-metal/get';
import DataRouteErrorMixin from 'client/mixins/routes/data-route-error';
import CanonicalUrlRedirectMixin from 'client/mixins/routes/canonical-url-redirect';

export default Route.extend(DataRouteErrorMixin, CanonicalUrlRedirectMixin, {
  model({ name }) {
    if (name.match(/\D+/)) {
      return get(this, 'store').query('user', { filter: { name } })
        .then((records) => get(records, 'firstObject'));
    } else {
      return get(this, 'store').findRecord('user', name);
    }
  }
});
