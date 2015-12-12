import Ember from 'ember';
import CanonicalUrlRedirect from 'client/mixins/canonical-url-redirect';

const {
  Route,
  get
} = Ember;

export default Route.extend(CanonicalUrlRedirect, {
  model(params) {
    const { slug } = params;
    if (slug.match(/\d+/)) {
      return get(this, 'store').findRecord('anime', slug);
    } else {
      return get(this, 'store').query('anime', { filter: { slug } })
        .then((records) => get(records, 'firstObject'));
    }
  },

  titleToken(model) {
    return get(model, 'canonicalTitle');
  }
});
