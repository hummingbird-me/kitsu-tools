import Ember from 'ember';
import CanonicalUrlRedirect from 'client/mixins/canonical-url-redirect';

const {
  Route,
  get
} = Ember;

export default Route.extend(CanonicalUrlRedirect, {
  model(params) {
    const { slug } = params;
    if (slug.match(/\D+/)) {
      return get(this, 'store').query('anime', { filter: { slug } })
        .then((records) => get(records, 'firstObject'));
    } else {
      return get(this, 'store').findRecord('anime', slug);
    }
  },

  titleToken(model) {
    return get(model, 'canonicalTitle');
  }
});
