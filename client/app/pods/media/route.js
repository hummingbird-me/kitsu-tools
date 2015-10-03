/*
  Single Ember.js Route that will work for all media types
*/
import Ember from 'ember';

const {
  Route,
  get,
  Logger
} = Ember;

// TODO: Figure out if different media types should just use different
// templates, or if they should not share any code at all.
export default Route.extend({
  model(params) {
    return this.store.findRecord(params.mediaType, params.mediaSlug);
  },

  serialize(model) {
    return {
      mediaType: model.constructor.modelName,
      mediaSlug: get(model, 'slug')
    };
  },

  actions: {
    error(reason) {
      Logger.log(reason);
      // `replaceWith` is used so we don't create a history record and break
      // the browser back button.
      this.replaceWith('/404');
    }
  }
});
