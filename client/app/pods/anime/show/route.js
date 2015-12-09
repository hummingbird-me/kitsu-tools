import Ember from 'ember';
import CanonicalUrlRedirect from 'client/mixins/canonical-url-redirect';

const {
  Route,
  get
} = Ember;

export default Route.extend(CanonicalUrlRedirect, {
  model(params) {
    return get(this, 'store').findRecord('anime', params.slug);
  },

  titleToken(model) {
    return get(model, 'canonicalTitle');
  }
});
