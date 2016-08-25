import Route from 'ember-route';
import get from 'ember-metal/get';
import DataErrorMixin from 'client/mixins/routes/data-error';
import CanonicalRedirectMixin from 'client/mixins/routes/canonical-redirect';

export default Route.extend(DataErrorMixin, CanonicalRedirectMixin, {
  model({ name }) {
    if (name.match(/\D+/)) {
      return get(this, 'store').query('user', { filter: { name } })
        .then((records) => get(records, 'firstObject'));
    } else {
      return get(this, 'store').findRecord('user', name);
    }
  }
});
