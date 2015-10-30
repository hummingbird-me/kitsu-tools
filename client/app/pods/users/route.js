import Ember from 'ember';
import DataRouteErrorMixin from 'client/mixins/data-route-error';

const {
  Route,
  get
} = Ember;

export default Route.extend(DataRouteErrorMixin, {
  model(params) {
    return get(this, 'store').findRecord('user', params.name);
  }
});
