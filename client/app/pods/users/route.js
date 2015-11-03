import Ember from 'ember';
import DataRouteErrorMixin from 'client/mixins/data-route-error';
import CanonicalUrlRedirect from 'client/mixins/canonical-url-redirect';

const {
  Route,
  get
} = Ember;

export default Route.extend(DataRouteErrorMixin, CanonicalUrlRedirect, {
  routeKey: 'name',

  model(params) {
    return get(this, 'store').findRecord('user', params.name);
  }
});
