import Ember from 'ember';

const {
  Route,
  get
} = Ember;

export default Route.extend({
  model(params) {
    return get(this, 'store').findRecord('anime', params.slug);
  },

  titleToken(model) {
    return get(model, 'canonicalTitle');
  }
});
