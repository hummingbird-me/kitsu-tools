/*
  Single Ember.js Route that will work for all media types
*/
import Ember from 'ember';
import DataRouteErrorMixin from 'client/mixins/data-route-error';

const {
  Route,
  get
} = Ember;

// TODO: Figure out if different media types should just use different
// templates, or if they should not share any code at all.
export default Route.extend(DataRouteErrorMixin, {
  model(params) {
    return this.store.findRecord('user', params.mediaSlug);
  },

  serialize(model) {
    return {
      mediaType: model.constructor.modelName,
      mediaSlug: get(model, 'slug')
    };
  }
});
