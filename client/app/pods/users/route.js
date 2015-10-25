import Ember from 'ember';
import DataRouteErrorMixin from 'client/mixins/data-route-error';

const {
  Route,
  get
} = Ember;

export default Route.extend(DataRouteErrorMixin, {
  model(params) {
    return get(this, 'store').findRecord('user', params.slug);
  },

  // Serialize the route to /user/:name when coming from a transition
  serialize(model) {
    const name = get(model, 'name');
    return { slug: name };
  }
});
