import Ember from 'ember';

export default Ember.Route.extend({
  queryParams: {
    query: { replace: true },
    filter: { replace: true }
  }
});
